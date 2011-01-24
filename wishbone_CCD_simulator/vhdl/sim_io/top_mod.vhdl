library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity top_module is
  port
    (
      -- External Clock
      clk         : in    std_logic;
      -- Interupt
      irq         : out   std_logic;
      -- Armadeus handshaking
      imx_data    : inout std_logic_vector(15 downto 0);
      imx_address : in    std_logic_vector(11 downto 0);
      imx_cs_n    : in    std_logic;
      imx_eb3_n   : in    std_logic;
      imx_oe_n    : in    std_logic;
      -- External pins
      a_in, b_in  : in    std_logic;
      sclk        : in    std_logic;
      STROBE      : in    std_logic
      );
end entity top_module;

architecture top_mod_1 of top_module is
  -- Components
  component wishbone_wrapper
    port (
      imx_address   : in    std_logic_vector(11 downto 0);
      imx_data      : inout std_logic_vector(15 downto 0);
      imx_cs_n      : in    std_logic;
      imx_oe_n      : in    std_logic;
      imx_eb3_n     : in    std_logic;
      gls_reset     : in    std_logic;
      gls_clk       : in    std_logic;
      wbm_address   : out   std_logic_vector(12 downto 0);
      wbm_readdata  : in    std_logic_vector(15 downto 0);
      wbm_writedata : out   std_logic_vector(15 downto 0);
      wbm_strobe    : out   std_logic;
      wbm_write     : out   std_logic;
      wbm_ack       : in    std_logic;
      wbm_cycle     : out   std_logic
      );
  end component;

  component irq_mngr
    generic(
      id        : natural   := 1;
      irq_level : std_logic := '1'
      );
    port (
      gls_clk          : in  std_logic;
      gls_reset        : in  std_logic;
      wbs_s1_address   : in  std_logic_vector(12 downto 0);
      wbs_s1_readdata  : out std_logic_vector(15 downto 0);
      wbs_s1_writedata : in  std_logic_vector(15 downto 0);
      wbs_s1_ack       : out std_logic;
      wbs_s1_strobe    : in  std_logic;
      wbs_s1_cycle     : in  std_logic;
      wbs_s1_write     : in  std_logic;
      irqport          : in  std_logic;
      gls_irq          : out std_logic
      );
  end component;

  component data_wbs_bridge
    port (
      clk                    : in  std_logic;
      STROBE                 : in  std_logic;
      a, b                   : in  std_logic_vector(7 downto 0);
      irq                    : out std_logic;
      wbs_strobe, wbs_cycle,
      wbs_write              : in  std_logic;
      wbs_readdata           : out std_logic_vector(15 downto 0);
      wbs_ack                : out std_logic
      );
  end component;

  component rstgen_syscon
    generic (
      invert_reset : std_logic := '0'
      );
    port (
      clk   : in  std_logic;
      reset : out std_logic
      );
  end component;

  component sclk_data_acq is
    port (
      clk  : in  std_logic;
      SCLK : in  std_logic;
      a_in : in  std_logic;
      b_in : in  std_logic;
      a, b : out std_logic_vector (7 downto 0)
      );
  end component;

  -- Signals
  -- Data vectors
  signal a, b               : std_logic_vector (7 downto 0);
  -- Reset and IRQ
  signal reset, managed_irq : std_logic;
  -- Wishbone Bus
  signal wb_address         : std_logic_vector (12 downto 0);
  signal wb_readdata,
    wb_writedata : std_logic_vector (15 downto 0);
  signal wb_strobe, wb_write,
    wb_ack, wb_cycle : std_logic;
begin
  
  wrapper : wishbone_wrapper
    port map (
      imx_address   => imx_address,
      imx_data      => imx_data,
      imx_cs_n      => imx_cs_n,
      imx_oe_n      => imx_oe_n,
      imx_eb3_n     => imx_eb3_n,
      gls_reset     => reset,
      gls_clk       => clk,
      wbm_address   => wb_address,
      wbm_readdata  => wb_readdata,
      wbm_writedata => wb_writedata,
      wbm_strobe    => wb_strobe,
      wbm_write     => wb_write,
      wbm_ack       => wb_ack,
      wbm_cycle     => wb_cycle
      );

  irq_mngr00 : irq_mngr
    generic map (
      id        => 1,
      irq_level => '1'
      )
    port map (
      gls_clk          => clk,
      gls_reset        => reset,
      wbs_s1_address   => wb_address,
      wbs_s1_readdata  => wb_readdata,
      wbs_s1_writedata => wb_writedata,
      wbs_s1_ack       => wb_ack,
      wbs_s1_strobe    => wb_strobe,
      wbs_s1_cycle     => wb_cycle,
      wbs_s1_write     => wb_write,
      irqport          => managed_irq,
      gls_irq          => irq
      );

  rstgen : rstgen_syscon
    generic map (
      invert_reset => '0'
      )
    port map (
      clk   => clk,
      reset => reset
      );

  bridge : data_wbs_bridge
    port map (
      clk          => clk,
      STROBE       => STROBE,
      a            => a,
      b            => b,
      irq          => managed_irq,
      wbs_strobe   => wb_strobe,
      wbs_cycle    => wb_cycle,
      wbs_write    => wb_write,
      wbs_readdata => wb_readdata,
      wbs_ack      => wb_ack
      );

  data_acq : sclk_data_acq
    port map (
      clk  => clk,
      SCLK => SCLK,
      a_in => a_in,
      b_in => b_in,
      a    => a,
      b    => b
      );

end architecture;
