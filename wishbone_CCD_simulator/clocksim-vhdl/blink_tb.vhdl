library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--  A testbench has no ports.
entity blink_tb is end blink_tb;

architecture behav of blink_tb is
  component Clk_div_led is
    generic (max_count : natural := 48000000);
    port (CLK : in  std_logic;
          cathode,anode : out std_logic);
  end component;
  --  Specifies which entity is bound with the component.
  for dut    : Clk_div_led use entity work.Clk_div_led;
  signal CLK : std_logic;
  signal cathode,anode : std_logic;
begin
  --  Component instantiation.
  --  We can only simulate a second at most, so max_count must be small
  dut : Clk_div_led generic map (max_count => 100)
    port map (CLK => CLK,
              cathode => cathode,
              anode => anode) ;
  process
    -- These control the looping we will do
    constant the_end : integer := 10000;
    variable count   : integer;
  begin
    CLK <= '1';
    for count in 0 to the_end loop
      wait for 15 ns;
      CLK <= not CLK;
    end loop;
    wait;
  end process;
end behav;
