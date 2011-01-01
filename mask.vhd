-- mask.vhd

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

entity mask is
  port (
    -- The clock
    clk       : in  std_logic;
    -- Flag for resetting the device
    reset     : in  std_logic;
    -- An event register
    event     : in  event_type;
    -- Flag which indicates that a new event is waiting
    waiting   : in  std_logic;
    -- Flag which pulses when we become idle
    idle      : out std_logic;
    -- The image array
    image_out : out image_array);
end mask;

architecture syn of mask is
  signal state_reg : integer range 1 to 2 := 1;
  signal shiftreg  : bit_vector (0 to (rom'length -1));
  signal image     : image_array;

  -- This is calculated in terms of the events array
  constant MINVAL : integer := 692;
  
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if (reset = '1') then
        -- If reset is high, initialize the machine
        state_reg <= 1;
        image     <= (others => 0);
        shiftreg  <= (others => '0');
        idle      <= '1';
      else
        -- Otherwise, read the state to see what to do
        case state_reg is
          when 1 =>
            if waiting = '1' then
              -- If there's data waiting, prepare the barrel
              -- shifter, and leave the idle state
              idle      <= '0';
              shiftreg  <= ROM sll (event - MINVAL);
              state_reg <= 2;
            end if;

          when 2 =>
            -- Loop through each bit of the barrel shifter
            -- and change image accordingly
            for i in 0 to (image_size) loop
              if shiftreg(i) = '1' then
                image(i) <= image(i) + 4;
              else
                image(i) <= image(i) - 1;
              end if;
            end loop;
            idle      <= '1';
            state_reg <= 1;
        end case;
      end if;
    end if;
  end process;
  image_out <= image;
end syn;
