library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.common_decs.all;

entity mask_tb is end mask_tb;

architecture behav of mask_tb is
  component mask is
    port (clk       : in  std_logic;
          reset     : in  std_logic;
          event     : in  event_type;
          waiting   : in  std_logic;
          idle      : out std_logic;
          image_out : out image_array);
  end component;
  -- The device under test is the mask
  for dut          : mask use entity work.mask;
  signal clk       : std_logic;
  signal reset     : std_logic;
  signal waiting   : std_logic;
  signal event     : event_type;
  signal idle      : std_logic;
  signal image_out : image_array;
begin
  --  Component instantiation.
  dut : mask
    port map (clk       => clk,
              reset     => reset,
              event     => event,
              waiting   => waiting,
              idle      => idle,
              image_out => image_out) ;
  process
    variable l     : line;
    variable n     : integer := 0;
    variable oidle : std_logic;
  begin
    -- Reset the unit
    clk   <= '0';
    reset <= '1';
    wait for 1 ns;
    clk   <= '1';
    wait for 1 ns;
    reset <= '0';

    -- Main loop
    waiting <= '1';
--    while finished /= '1' loop
    while n < events'length loop
      -- Fixme: Not very elegant
      event <= events(n);
      oidle := idle;
      wait for 1 ns;
      clk   <= not clk;
      wait for 1 ns;

      -- A poor man's rising_edge()
      if (idle = '1' and idle /= oidle) then
--        report integer'image(n);
        n := n + 1;
      end if;
    end loop;
    waiting <= '0';

    -- Output results
    for i in 0 to image_size loop
      write (l, string'(integer'image(image_out(i))));
      writeline (output, l);
    end loop;
    wait;
  end process;
end behav;
