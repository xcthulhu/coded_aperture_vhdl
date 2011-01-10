library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Clk_div_led is
  generic (max_count : natural := 48000000);
  port (CLK         : in  std_logic;
        led_cathode : out std_logic;
        led_anode   : out std_logic);
end Clk_div_led;

architecture RTL of Clk_div_led is
  signal Rst_n       : std_logic;
begin
  
  Rst_n       <= '1';
  led_cathode <= '0';

  -- compteur de 0 à max_count
  compteur : process(Clk, Rst_n)
    variable count : natural range 0 to max_count;
  begin
    if Rst_n = '0' then
      count     := 0;
      led_anode <= '1';
    elsif rising_edge(Clk) then
      if count < max_count/2 then
        led_anode <= '1';
        count     := count + 1;
      elsif count < max_count then
        led_anode <= '0';
        count     := count + 1;
      else
        count     := 0;
        led_anode <= '1';
      end if;
    end if;
  end process compteur;
end RTL;
