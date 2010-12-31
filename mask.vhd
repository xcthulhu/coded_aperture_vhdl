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

-- the types event_type and image_array
-- and the constant image_size
-- are all declared in the common_decs package
use work.common_decs.all;

-- the ROM is declared as a constant in the ROM package
use work.rom.all;

entity data_process is
  port (clk       : in  std_logic;
        reset     : in  std_logic;
        --waiting   : in  std_logic;
        --event     : in  event_type;
        finished  : out std_logic;
        image_out : out image_array);
end data_process;

architecture syn of data_process is
  signal state_reg : integer range 0 to 5              := 0;
  signal shiftreg  : bit_vector (0 to (rom'length -1)) := (others => '0');

  -- These are all calculated in terms of the events array
  constant MINVAL   : integer := 692;
  constant MAXVAL   : integer := 942;
  constant MAXLOOPS : integer := events_array'length;

  signal nshifts : integer range 0 to 4095;
  signal done    : std_logic   := '0';
  signal nloops  : integer range 0 to 750;
  signal nval    : integer range 0 to 500;
  signal image   : image_array := (others => 0);
  
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        done  <= '0';
        image <= (others => 0);
      else
        case state_reg is
          when 0 =>
            if (done = '0') then
              state_reg <= 1;
              nloops    <= 0;
            end if;
--  load shift register and determine number of shifts
          when 1 =>
            if (done = '0') then
              shiftreg  <= ROM;
              nshifts   <= events(nloops) - MINVAL;
              nloops    <= nloops + 1;
              state_reg <= 2;
            end if;
--   shift the SR 
          when 2 =>
            shiftreg  <= shiftreg sll nshifts;
            state_reg <= 3;
--  loop through each bit of SR and change image according to SR bit       
          when 3 =>
            for i in 0 to (image_size) loop
              if shiftreg(i) = '1' then
                image(i) <= image(i) + 4;
              else
                image(i) <= image(i) - 1;
              end if;
            end loop;
            state_reg <= 4;
--  determine whether all loops have been done
          when 4 =>
            if (nloops > (MAXLOOPS-1)) then
              state_reg <= 5;
            else
              state_reg <= 1;
            end if;

--  output 250 image elements then its done   
          when 5 =>
            done      <= '1';
            state_reg <= 5;
        end case;
      end if;
    end if;
  end process;
  image_out <= image;
  finished  <= done;
end syn;
