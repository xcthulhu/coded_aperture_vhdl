library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--  A testbench has no ports.
entity data_wbs_bridge_tb is end data_wbs_bridge_tb;

architecture behav of data_wbs_bridge_tb is
  component data_wbs_bridge is
    port (CLK         : in  std_logic;
          led_cathode : out std_logic;
          led_anode   : out std_logic);
  end component;
  --  Specifies which entity is bound with the component.
  for dut            : Clk_div_led use entity work.Clk_div_led;
  signal CLK         : std_logic;
  signal led_cathode : std_logic;
  signal led_anode   : std_logic;
begin
  --  Component instantiation.
  --  We can only simulate a second at most, so max_count must be small
  dut : data_wbs_bridge
    port map (CLK         => CLK,
              led_cathode => led_cathode,
              led_anode   => led_anode) ;
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
