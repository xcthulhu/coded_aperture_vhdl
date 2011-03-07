library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-- C emulation library for printf
library C;
use C.stdio_h.all;

-- A testbench has no ports
entity clocksim_tb is end;

architecture behav of clocksim_tb is
  component top_mod is
    generic (div : natural := 100);
    port (CLK                          : in  std_logic;
          SCLK_cathode, SCLK_anode     : out std_logic;
          STROBE_cathode, STROBE_anode : out std_logic;
          A_cathode, A_anode           : out std_logic;
          B_cathode, B_anode           : out std_logic);
  end component;
  --  Specifies which entity is bound with the component.
  for dut    : top_mod use entity work.top_mod;
  signal CLK : std_logic;
  signal SCLK_cathode, SCLK_anode,
    STROBE_cathode, STROBE_anode,
    A_cathode, A_anode,
    B_cathode, B_anode : std_logic;
begin
  --  Component instantiation.
  --  We can only simulate a second at most, so max_count must be small
  dut : top_mod generic map (div => 1)
    port map (CLK            => CLK,
              SCLK_cathode   => SCLK_cathode,
              SCLK_anode     => SCLK_anode,
              STROBE_cathode => STROBE_cathode,
              STROBE_anode   => STROBE_anode,
              A_cathode      => A_cathode,
              A_anode        => A_anode,
              B_cathode      => B_cathode,
              B_anode        => B_anode);
  process
    -- These control the looping we will do
    constant the_end : integer := 500;
    variable count   : integer;
    variable old_SCLK : std_logic := SCLK_anode;
  begin
    printf("#SCLK SEQA SEQB STROBE\n");
    CLK <= '1';
    for count in 0 to the_end loop
      if (SCLK_anode /= old_SCLK) then
        printf("%u ", SCLK_anode);
        printf("%u ", A_anode);
        printf("%u ", B_anode);
        printf("%u\n", STROBE_anode);
      end if;
      old_SCLK := SCLK_anode;
      wait for 15 ns;
      CLK <= not CLK;
    end loop;
    wait;
  end process;
end;
