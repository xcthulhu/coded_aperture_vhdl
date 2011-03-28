library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;
use work.clocksim_decs.all;

library unisim;
use unisim.Vcomponents.all;

entity top_mod is
  port
    (
      -- External Clock
      clk                     : in    std_logic;
      -- Interupt
      irq                     : out   std_logic;
      -- Armadeus handshaking
      imx_data                : inout imx_chan;
      imx_address             : in    std_logic_vector(11 downto 0);  -- LSB not used 
      imx_cs_n                : in    std_logic;
      imx_oe_n                : in    std_logic;
      imx_eb3_n               : in    std_logic;
      -- External pins
      ---- Inputs
      a_in, a_inb,
      b_in, b_inb             : in    std_logic;
      SCLK_in, SCLK_inb       : in    std_logic;
      STROBE_in, STROBE_inb   : in    std_logic;
      ---- Outputs
      a_out, a_outb,
      b_out, b_outb           : out   std_logic;
      SCLK_out, SCLK_outb     : out   std_logic;
      STROBE_out, STROBE_outb : out   std_logic
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
      irqport : in  write_chan;
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
    generic (id        : device_id := x"0523";
             addrdepth : integer   := 9
             );
    port
      (
        sysc         : in  syscon;
        a_in, b_in,
        SCLK, STROBE : in  std_logic;
        irqport      : out write_chan;
        wbw          : in  wbws;
        wbr          : out wbrs
        );
  end component;

  component clocksim is
    generic (div : natural := 100);
    port (sysc               : in  syscon;
          SCLK, STROBE, A, B : out std_logic);
  end component;

  -- External Pins
  signal xa_in, xb_in, xSCLK_in, xSTROBE_in : std_logic;
  signal xa_out, xb_out, xSCLK_out, xSTROBE_out : std_logic;

  -- IRQ communication
  signal irqport : write_chan;

  ---- Intercon
  signal sysc, irq_sysc, fifo_sysc, wsysc : syscon;
  signal wwbr, irq_wbr, fifo_wbr          : wbrs;
  signal wwbw, irq_wbw, fifo_wbw          : wbws;
  signal imx                              : imx_in;
  
begin
  imx.address <= imx_address;
  imx.cs_n    <= imx_cs_n;
  imx.oe_n    <= imx_oe_n;
  imx.eb3_n   <= imx_eb3_n;

  IO_L01X_0 : IBUFDS
    port map ( I  => a_in,
               IB => a_inb,
               O  => xa_in);

  IO_L03X_0 : IBUFDS
    port map ( I  => b_in,
               IB => b_inb,
               O  => xb_in);

  IO_L07X_0 : IBUFDS
    port map ( I  => SCLK_in,
               IB => SCLK_inb,
               O  => xSCLK_in);

  IO_L15X_0 : IBUFDS
    port map ( I  => STROBE_in,
               IB => STROBE_inb,
               O  => xSTROBE_in);

  rstgen00 : rstgen_syscon
    generic map (invert_reset => '0')
    port map ( clk  => clk,
               sysc => sysc);

  intercon00 : intercon
    port map ( sysc      => sysc,
               irq_wbr   => irq_wbr,
               irq_wbw   => irq_wbw,
               irq_sysc  => irq_sysc,
               fifo_wbr  => fifo_wbr,
               fifo_wbw  => fifo_wbw,
               fifo_sysc => fifo_sysc,
               wwbr      => wwbr,
               wwbw      => wwbw,
               wsysc     => wsysc);

  wrapper : wishbone_wrapper
    port map ( sysc     => wsysc,
               imx_data => imx_data,
               imx      => imx, 
               wbw      => wwbw,
               wbr      => wwbr);

  irq_mngr00 : irq_mngr
    generic map ( id        => x"1009",
                  irq_level => '1')
    port map ( sysc    => irq_sysc,
               wbr     => irq_wbr,
               wbw     => irq_wbw,
               irqport => irqport,
               irq     => irq);

  wb_fifo_chain00 : wb_fifo_chain
    generic map (
      id        => x"0523",
      addrdepth => 9
      )
    port map (
      sysc    => fifo_sysc,
      a_in    => xa_in,
      b_in    => xb_in,
      STROBE  => xSTROBE_in,
      SCLK    => xSCLK_in,
      irqport => irqport,
      wbw     => fifo_wbw,
      wbr     => fifo_wbr
      );

-- Output System
  
  SCLK_LVDS_OUT : OBUFDS
    port map (I  => xSCLK_out,
              O  => SCLK_out,
              OB => SCLK_outb);

  STROBE_LVDS_OUT : OBUFDS
    port map (I  => xSTROBE_out,
              O  => STROBE_out,
              OB => STROBE_outb);

  A_LVDS_OUT : OBUFDS
    port map (I  => xa_out,
              O  => a_out,
              OB => a_outb);

  B_LVDS_OUT : OBUFDS
    port map (I  => xb_out,
              O  => b_out,
              OB => b_outb);

  CLOCKSIMULATOR : clocksim
    generic map (div => 100000000)
    port map (sysc   => sysc,
              SCLK   => xSCLK_out,
              STROBE => xSTROBE_out,
              A      => xa_out,
              B      => xb_out);
  
end architecture;
