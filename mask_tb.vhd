library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.common_decs.all;

entity mask_tb is end mask_tb;

architecture behav of mask_tb is
  component data_process is
    port (clk       : in  std_logic;
          reset     : in  std_logic;
          --waiting   : in  std_logic;
          --event     : in  event_type;
          finished  : out std_logic;
          image_out : out image_array);
  end component;
  -- The device under test is the data_process
  for dut          : data_process use entity work.data_process;
  signal clk       : std_logic;
  signal reset     : std_logic;
  --signal waiting   : std_logic;
  --signal event     : event_type;
  signal finished  : std_logic;
  signal image_out : image_array;
begin
  --  Component instantiation.
  dut : data_process
    port map (clk       => clk,
              reset     => reset,
              --waiting   => waiting,
              --event     => event,
              finished  => finished,
              image_out => image_out) ;
  process
    variable l : line;
  begin
    -- Reset the unit
    clk   <= '0';
    reset <= '1';
    wait for 2 ns;
    clk   <= '1';
    reset <= '0';
    while not (finished = '1') loop
      wait for 2 ns;
      clk <= not clk;
      wait for 2 ns;
    end loop;
    for i in 0 to image_size loop
      write (l, string'(integer'image(image_out(i))));
      writeline (output, l);
    end loop;
    wait;
  end process;
end behav;
