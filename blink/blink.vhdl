library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library unisim;
use unisim.Vcomponents.all;

entity Clk_div_led is
  generic (max_count : natural := 48000000);
  port (CLK : in  std_logic;
        led : out std_logic);
end Clk_div_led;

architecture RTL of Clk_div_led is
  signal x : std_logic;
begin
  
  IO_L24P_1 : OBUF
    port map (I => x,
              O => led);

  -- compteur de 0 à max_count
  compteur : process(Clk)
    variable count : natural range 0 to max_count;
  begin
    if rising_edge(Clk) then
      if count < max_count/2 then
        x     <= '1';
        count := count + 1;
      elsif count < max_count then
        x     <= '0';
        count := count + 1;
      else
        x     <= '1';
        count := 0;
      end if;
    end if;
  end process compteur;
end RTL;
