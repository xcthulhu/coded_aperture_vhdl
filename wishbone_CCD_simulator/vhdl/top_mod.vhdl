library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity top_mod is
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
end entity;

architecture RTL of top_mod is
  -- Components
  component wishbone_wrapper
    port (
      reset    : in    std_logic;
      clk      : in    std_logic;
      imx_data : inout std_logic_vector(chan_size-1 downto 0);
      imx      : in    imx_in;
      wbr      : in    wbr;
      wbw      : out   wbw
      );
  end component;

  component irq_mngr
    generic(
      id        : device_id := x"1009";
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

  component intercon
    port (
      clk, reset                 : in  std_logic;
      irq_wbr, fifo_wbr          : in  wbr;
      irq_wbw, fifo_wbw          : out wbw;
      irq_clk, irq_reset,
      fifo_clk, fifo_reset,
      wrapper_clk, wrapper_reset : out std_logic;
      gwbr                       : out wbr;
      gwbw                       : in  wbw
      );
  end component;

  component wb_fifo is
    generic
      (id : device_id := x"0523");
    port
      (
        clk, reset, wr_en : in  std_logic;
        din               : in  std_logic_vector(chan_size-1 downto 0);
        irqport           : out std_logic;
        wbw               : in  wbw;
        wbr               : out wbr
        );
  end component;

  component data_bridge
    port (
      clk, STROBE : in  std_logic;
      a, b        : in  std_logic_vector(7 downto 0);
      wr_en       : out std_logic;
      dout        : out std_logic_vector(15 downto 0)
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
  ---- Data vectors
  signal a, b       : std_logic_vector (7 downto 0);
  signal bridge_out : std_logic_vector(chan_size-1 downto 0);

  ---- Write Instruction for FIFO
  signal wr_en : std_logic;

  ---- Reset and IRQ
  signal reset, irqport : std_logic;

  ---- Intercon
  signal irq_clk, irq_reset,
    fifo_clk, fifo_reset,
    wrapper_clk, wrapper_reset : std_logic;
  signal gwbr, irq_wbr, fifo_wbr : wbr;
  signal gwbw, irq_wbw, fifo_wbw : wbw;

begin

  intercon00 : intercon
    port map
    (
      clk           => clk,
      reset         => reset,
      irq_wbr       => irq_wbr,
      irq_wbw       => irq_wbw,
      irq_clk       => irq_clk,
      irq_reset     => irq_reset,
      fifo_wbr      => fifo_wbr,
      fifo_wbw      => fifo_wbw,
      fifo_clk      => fifo_clk,
      fifo_reset    => fifo_reset,
      gwbr          => gwbr,
      gwbw          => gwbw,
      wrapper_clk   => wrapper_clk,
      wrapper_reset => wrapper_reset
      );

  wrapper : wishbone_wrapper
    port map (
      reset    => wrapper_reset,
      clk      => wrapper_clk,
      imx_data => imx_data,
      imx      => imx,
      wbw      => gwbw,
      wbr      => gwbr
      );

  irq_mngr00 : irq_mngr
    generic map (
      id        => x"1009",
      irq_level => '1'
      )
    port map (
      clk     => irq_clk,
      reset   => irq_reset,
      wbr     => irq_wbr,
      wbw     => irq_wbw,
      irqport => irqport,
      irq     => irq
      );

  wb_fifo00 : wb_fifo
    generic map (
      id => x"0523"
      )
    port map (
      clk     => fifo_clk,
      reset   => fifo_reset,
      irqport => irqport,
      din     => bridge_out,
      wr_en   => wr_en,
      wbw     => fifo_wbw,
      wbr     => fifo_wbr
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
      clk    => clk,
      STROBE => STROBE,
      a      => a,
      b      => b,
      dout   => bridge_out,
      wr_en  => wr_en
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
