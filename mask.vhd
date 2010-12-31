-- mask.vhd
-- 800 bit version
-- start with events and mask in memory; 
-- process events with mask and generate image
--
-- inputs: cmd_start is triggered by 'cmd_start' signal going high
--
-- outputs: 'finished' goes high to indicate when process is complete
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.common_decs.all;
use work.rom.all;

entity data_process is
  port (clk       : in  std_logic;
        reset : in  std_logic;
        finished  : out std_logic;
        valid     : out std_logic;
        startclk  : out std_logic;
        test_data : out std_logic_vector(0 to 15)); 
end data_process;


architecture syn of data_process is
  signal state_reg : integer range 0 to 5 := 0;
  signal shiftreg : bit_vector (0 to 799) := (others => '0');
  -- FIXME: We should just use std_logic_vectors as counters
  signal image : image_array := (others => 0);
  
  -- These are all calculated in terms of the events array
  constant MINVAL   : integer := 692;
  constant MAXVAL   : integer := 942;
  constant MAXLOOPS : integer := events_array'length;

  signal nshifts : integer range 0 to 4095;
  signal done    : std_logic := '0';
  signal nloops  : integer range 0 to 750;
  signal nval    : integer range 0 to 500;
  
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
            finished <= '0';
            done     <= '0';
            image <= (others => 0);
      else
      case state_reg is
--  hold for cmd_start or after process is done          
        when 0 =>
          valid    <= '0';
          startclk <= '0';
          if (done = '0') then
            state_reg <= 1;
            nloops    <= 0;
            startclk  <= '1';
          end if;
--  load shift register and determine number of shifts
        when 1 =>
          valid    <= '0';
          startclk <= '1';
          if (done = '0') then
            shiftreg  <= ROM;
            nshifts   <= events(nloops) - MINVAL;
            nloops    <= nloops + 1;
            state_reg <= 2;
          end if;
--   shift the SR 
        when 2 =>
          valid     <= '0';
          startclk  <= '1';
          shiftreg  <= shiftreg sll nshifts;
          state_reg <= 3;
--  loop through each bit of SR and change image according to SR bit       
        when 3 =>
          valid    <= '0';
          startclk <= '1';
          for i in 0 to 249 loop
            if shiftreg(i) = '1' then
              image(i) <= image(i) + 4;
            else
              image(i) <= image(i) - 1;
            end if;
          end loop;
          state_reg <= 4;
--  determine whether all loops have been done
        when 4 =>
          valid    <= '0';
          startclk <= '1';
          if (nloops > (MAXLOOPS-1)) then
            state_reg <= 5;
          else
            state_reg <= 1;
          end if;

--  output 250 image elements then its done   
        when 5 =>
          if (nloops > (MAXLOOPS + 249)) then
            nloops    <= 0;
            finished  <= '1';
            done      <= '1';
            state_reg <= 0;
            valid     <= '0';
            startclk  <= '0';
          else
            test_data <= std_logic_vector(to_signed(image(nloops-MAXLOOPS), 16));
            valid     <= '1';
            startclk  <= '1';
            state_reg <= 5;
            nloops    <= nloops + 1;
          end if;
      end case;
      end if;
    end if;
  end process;
end syn;

