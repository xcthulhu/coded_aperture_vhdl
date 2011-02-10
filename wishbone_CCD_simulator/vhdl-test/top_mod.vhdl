library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity top_mod is
  port
    (
      -- External Clock
      clk      : in  std_logic;
      led      : out std_logic;
      test_pin : in  std_logic
      );
end entity;

architecture RTL of top_mod is
begin
  blink_test : process(clk)
    variable previous_pinval : std_logic := '1';
  begin
    if rising_edge(clk) then
      if (test_pin /= previous_pinval and test_pin = '1') then
        led <= '1';
      else
        led <= '0';
      end if;
      previous_pinval := test_pin;
    end if;
  end process blink_test;
end;
