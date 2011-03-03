library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity intercon is
  port
    (
      -- Global Signals
      sysc : in syscon;

      -- IRQ signals
      irq_wbr  : in  wbrs;
      irq_wbw  : out wbws;
      irq_sysc : out syscon;

      -- FIFO signals
      fifo_wbr  : in  wbrs;
      fifo_wbw  : out wbws;
      fifo_sysc : out syscon;

      -- Wishbone Wrapper
      ---- These are what we are multiplexing
      wwbr  : out wbrs;
      wwbw  : in  wbws;
      wsysc : out syscon
      );
end entity;

architecture RTL of intercon is
  signal readdata : read_chan;
begin
  process(sysc.clk)
  begin
    if rising_edge(sysc.clk) then
      case wwbw.c.address is
        when "000000000000" => readdata <= x"F473";
        when "000000000001" => readdata <= x"F00F";
        when "000000000010" => readdata <= x"1337";
        when "000000000011" => readdata <= x"D0D0";
        when "000000000100" => readdata <= x"DEAD";
        when others         => readdata <= (others => '0');
      end case;
    end if;
  end process;
  wwbr.readdata <= readdata;
end architecture;
