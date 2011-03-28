library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library unisim;
use unisim.Vcomponents.all;

use work.clocksim_decs.all;
use work.common_decs.all;

entity top_mod is
  generic (div : natural := 100);
  port (CLK            : in  std_logic;
        SCLK_out, SCLK_outb     : out std_logic;
        STROBE_out, STROBE_outb   : out std_logic;
        A_out, A_outb        : out std_logic;
        B_out, B_outb        : out std_logic);
end;

architecture RTL of top_mod is
  signal xSCLK_out, xSTROBE_out,
    xA_out, xB_out : std_logic;
  signal sysc                  : syscon;

  component rstgen_syscon
    port ( clk  : in  std_logic;
           sysc : out syscon);
  end component;

  component clocksim
    generic (div : natural := 100);
    port ( sysc               : in  syscon;
           SCLK, STROBE, A, B : out std_logic);
  end component;

begin
  SCLK_LVDS_OUT : OBUFDS
    port map (I  => xSCLK_out,
              O  => SCLK_out,
              OB => SCLK_outb);

  STROBE_LVDS_OUT : OBUFDS
    port map (I  => xSTROBE_out,
              O  => STROBE_out,
              OB => STROBE_outb);

  A_LVDS_OUT : OBUFDS
    port map (I  => xA_out,
              O  => A_out,
              OB => A_outb);

  B_LVDS_OUT : OBUFDS
    port map (I  => xB_out,
              O  => B_out,
              OB => B_outb);

  RESETER : rstgen_syscon
    port map (CLK  => CLK,
              sysc => sysc);

  CLOCKSIMULATOR : clocksim
    generic map (div => div)
    port map (sysc   => xsysc_out,
              SCLK   => xSCLK_out,
              STROBE => xSTROBE_out,
              A      => xA_out,
              B      => xB_out);

end;
