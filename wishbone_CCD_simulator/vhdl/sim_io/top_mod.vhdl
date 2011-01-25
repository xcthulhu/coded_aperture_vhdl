library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity top_module is
  port
    (
      -- External Clock
      clk        : in    std_logic;
      -- Interupt
      irq        : out   std_logic;
      -- Armadeus handshaking
      imx_data   : inout std_logic_vector(15 downto 0);
      imx        : in    imx_in;
      -- External pins
      a_in, b_in : in    std_logic;
      SCLK       : in    std_logic;
      STROBE     : in    std_logic
      );
end entity top_module;

architecture RTL of top_module is
  -- Components
  component wishbone_wrapper
    port (
      reset    : in    std_logic;
      clk      : in    std_logic;
      imx_data : inout std_logic_vector(15 downto 0);
      imx      : in    imx_in;
      wbr      : in    wbr;
      wbw      : out   wbw
      );
  end component;

  component irq_mngr
    generic(
      id        : natural   := 1;
      irq_level : std_logic := '1'
      );
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      wbw     : in  wbw;
      wbr     : out wbr;
      irqport : in  std_logic;
      irq     : out std_logic
      );
  end component;

  component data_bridge
    port (
      clk     : in  std_logic;
      STROBE  : in  std_logic;
      a, b    : in  std_logic_vector(7 downto 0);
      irqport : out std_logic;
      wbw     : in  wbw;
      wbr     : out wbr
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
  signal a, b           : std_logic_vector (7 downto 0);
  -- Reset and IRQ
  signal reset, irqport : std_logic;
  -- Wishbone Bus
  signal wbw            : wbw;
  signal wbr            : wbr;
begin
  
  wrapper : wishbone_wrapper
    port map (
      reset    => reset,
      clk      => clk,
      imx_data => imx_data,
      imx      => imx,
      wbw      => wbw,
      wbr      => wbr
      );

  irq_mngr00 : irq_mngr
    generic map (
      id        => 1,
      irq_level => '1'
      )
    port map (
      clk     => clk,
      reset   => reset,
      irqport => irqport,
      irq     => irq
      );

  rstgen : rstgen_syscon
    generic map (
      invert_reset => '0'
      )
    port map (
      clk   => clk,
      reset => reset
      );

  bridge : data_bridge
    port map (
      clk     => clk,
      STROBE  => STROBE,
      a       => a,
      b       => b,
      irqport => irqport,
      wbw     => wbw,
      wbr     => wbr
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
