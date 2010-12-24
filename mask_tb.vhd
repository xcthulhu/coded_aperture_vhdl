library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity mask_tb is end mask_tb;

architecture behav of mask_tb is
  component data_process is
    port (clk       : in  std_logic;
          cmd_start : in  std_logic;
          finished  : out std_logic;
          valid     : out std_logic;
          startclk  : out std_logic;
          test_data : out std_logic_vector(0 to 15));
  end component;
  -- The device under test is the data_process
  for dut          : data_process use entity work.data_process;
  signal clk       : std_logic;
  signal cmd_start : std_logic;
  signal finished  : std_logic;
  signal valid     : std_logic;
  signal startclk  : std_logic;
  signal test_data : std_logic_vector(0 to 15);
begin
  --  Component instantiation.
  dut : data_process
    port map (clk       => clk,
              cmd_start => cmd_start,
              finished  => finished,
              valid     => valid,
              startclk  => startclk,
              test_data => test_data) ;
  process
    variable l : line;
  begin
    -- Initialize the clock and the start command
    clk       <= '0';
    cmd_start <= '0';
    wait for 2 ns;
    clk       <= '0';
    cmd_start <= '1';
    -- FIXME:  This should loop until "finished" is high maybe?
    while finished = '0' loop
      wait for 2 ns;
      clk <= not clk;
      wait for 2 ns;
    end loop;
    write (l, string'("Hello world!"));
    writeline (output, l);
    wait;
  end process;
end behav;
