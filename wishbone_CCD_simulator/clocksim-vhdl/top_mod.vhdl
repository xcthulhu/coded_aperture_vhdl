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
        SCLK_anode     : out std_logic;
        SCLK_cathode   : out std_logic;
        STROBE_anode   : out std_logic;
        STROBE_cathode : out std_logic;
        A_anode        : out std_logic;
        A_cathode      : out std_logic;
        B_anode        : out std_logic;
        B_cathode      : out std_logic);
end;

architecture RTL of top_mod is
  signal iSCLK, iStrobe, iA, iB : std_logic;
  signal isysc                  : syscon;

  component rstgen_syscon
    port (clk  : in  std_logic;
          sysc : out syscon);
  end component;

  component clocksim
    generic (div : natural := 100);
    port (sysc               : in  syscon;
          SCLK, STROBE, A, B : out std_logic);
  end component;

begin
  SCLK_LVDS_OUT : OBUFDS
    port map (I  => iSCLK,
              O  => SCLK_anode,
              OB => SCLK_cathode);

  STROBE_LVDS_OUT : OBUFDS
    port map (I  => iSTROBE,
              O  => STROBE_anode,
              OB => STROBE_cathode);

  A_LVDS_OUT : OBUFDS
    port map (I  => iA,
              O  => A_anode,
              OB => A_cathode);

  B_LVDS_OUT : OBUFDS
    port map (I  => iB,
              O  => B_anode,
              OB => B_cathode);

  RESETER : rstgen_syscon
    port map (CLK  => CLK,
              sysc => isysc);

  CLOCKSIMULATOR : clocksim
    generic map (div => div)
    port map (sysc   => isysc,
              SCLK   => iSCLK,
              STROBE => iSTROBE,
              A      => iA,
              B      => iB);

end;
