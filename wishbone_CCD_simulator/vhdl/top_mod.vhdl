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
      imx_data   : inout imx_chan;
      imx        : in    imx_in;
      -- External pins
      a_in, b_in : in    std_logic;
      SCLK       : in    std_logic;
      STROBE     : in    std_logic
      );
end entity;

architecture RTL of top_mod is
  -- Components

  component rstgen_syscon
    generic (invert_reset : std_logic := '0');
    port (
      clk  : in  std_logic;
      sysc : out syscon
      );
  end component;

  component wishbone_wrapper
    port (
      sysc     : in    syscon;
      imx_data : inout imx_chan;
      imx      : in    imx_in;
      wbr      : in    wbrs;
      wbw      : out   wbws
      );
  end component;

  component irq_mngr
    generic(
      id        : device_id := x"1009";
      irq_level : std_logic := '1'
      );
    port (
      sysc    : in  syscon;
      wbw     : in  wbws;
      wbr     : out wbrs;
      irqport : in  irq_port;
      irq     : out std_logic
      );
  end component;

  component intercon
    port (
      sysc              : in  syscon;
      irq_wbr, fifo_wbr : in  wbrs;
      irq_wbw, fifo_wbw : out wbws;
      irq_sysc, fifo_sysc,
      wsysc             : out syscon;
      wwbr              : out wbrs;
      wwbw              : in  wbws
      );
  end component;

  component wb_fifo_chain is
    generic (id : device_id := x"0523");
    port
      (
        sysc         : in  syscon;
        a_in, b_in,
        SCLK, STROBE : in  std_logic;
        irqport      : out irq_port;
        wbw          : in  wbws;
        wbr          : out wbrs
        );
  end component;

  -- IRQ communication
  signal irqport : irq_port;

  ---- Intercon
  signal sysc, irq_sysc, fifo_sysc, wsysc : syscon;
  signal wwbr, irq_wbr, fifo_wbr          : wbrs;
  signal wwbw, irq_wbw, fifo_wbw          : wbws;
  
begin

  rstgen00 : rstgen_syscon
    generic map (invert_reset => '0')
    port map (
      clk  => clk,
      sysc => sysc
      );

  intercon00 : intercon
    port map (
      sysc      => sysc,
      irq_wbr   => irq_wbr,
      irq_wbw   => irq_wbw,
      irq_sysc  => irq_sysc,
      fifo_wbr  => fifo_wbr,
      fifo_wbw  => fifo_wbw,
      fifo_sysc => fifo_sysc,
      wwbr      => wwbr,
      wwbw      => wwbw,
      wsysc     => wsysc
      );

  wrapper : wishbone_wrapper
    port map (
      sysc     => wsysc,
      imx_data => imx_data,
      imx      => imx,
      wbw      => wwbw,
      wbr      => wwbr
      );

  irq_mngr00 : irq_mngr
    generic map (
      id        => x"1009",
      irq_level => '1'
      )
    port map (
      sysc    => irq_sysc,
      wbr     => irq_wbr,
      wbw     => irq_wbw,
      irqport => irqport,
      irq     => irq
      );

  wb_fifo_chain00 : wb_fifo_chain
    generic map (id => x"0523")
    port map (
      sysc    => fifo_sysc,
      a_in    => a_in,
      b_in    => b_in,
      STROBE  => STROBE,
      SCLK    => SCLK,
      irqport => irqport,
      wbw     => fifo_wbw,
      wbr     => fifo_wbr
      );

end architecture;
