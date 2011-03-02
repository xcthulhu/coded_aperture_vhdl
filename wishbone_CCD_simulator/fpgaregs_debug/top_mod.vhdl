library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

library unisim;
use unisim.Vcomponents.all;

entity top_mod is
  port
    (
      -- External Clock
      clk         : in    std_logic;
      -- Interupt
      irq         : out   std_logic;
      -- Armadeus handshaking
      imx_data    : inout imx_chan;
      imx_address : in std_logic_vector(11 downto 0);  -- LSB not used 
      imx_cs_n    : in std_logic;
      imx_oe_n    : in std_logic;
      imx_eb3_n   : in std_logic
      );
end entity;

architecture RTL of top_mod is
   signal read_data : imx_chan;
begin
  process(clk) begin
	if rising_edge(clk) then
		case imx_address is
			when "000000000001" => read_data <= x"F00F";
			when "000000000010" => read_data <= x"1337";
			when "000000000011" => read_data <= x"D0D0";
			when "000000000100" => read_data <= x"DEAD";
			when others => read_data <= (others => '0');
		end case;
	end if;
  end process;

  imx_data <= read_data when (not (imx_cs_n or imx_oe_n) = '1') 
			else (others => 'Z');

end architecture;
