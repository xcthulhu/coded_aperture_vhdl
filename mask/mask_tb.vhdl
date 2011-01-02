library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use work.common_decs.all;

-- Using C functions hacked into VHDL *IS* cheating...
library C;
use C.stdio_h.all;

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
  signal clk       : std_logic := '0';
  signal reset     : std_logic;
  signal waiting   : std_logic := '1';
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

  -- Clock behavior
  clk <= unaffected when waiting = '0'
         else not clk after 1 ns;
  process
    variable fin   : CFILE;
    variable n     : integer := 0;
    variable oidle : std_logic;
  begin
    -- Acquire data from "events.dat"
    -- and set up first event
    fin   := fopen("events.dat", "r");
    fscanf(fin, "%d", n);
    event <= n;
    
    -- Reset the mask array
    reset <= '1';
    wait for 2 ns;
    reset <= '0';

    -- Enter the main loop
    while true loop
      -- This is messy and I wish I didn't need oidle
      --wait on idle until idle = '0';
      oidle := idle;
      wait for 1 ns;
      if idle = '1' and idle /= oidle then
        if feof(fin) then exit;
        else
          fscanf(fin, "%d", n);
          event <= n;
        end if;
      end if;
    end loop;
    fclose(fin);
    waiting <= '0';

    -- Print the results
    for i in 0 to image_size loop
      printf("%d\n", image_out(i));
    end loop;
    
    wait;
  end process;
end behav;
