---------------------------------------------------------------------------
-- Company     : ARMades Systems
-- Author(s)   : Fabien Marteau <fabien.marteau@armadeus.com>
-- 
-- Creation Date : 10/03/2008
-- File          : button.vhd
--
-- Abstract : 
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

---------------------------------------------------------------------------
Entity button is 
---------------------------------------------------------------------------
    generic(
        id : natural := 2
    );
	port 
	(
		-- global signals
		gls_reset : in std_logic ;
		gls_clk 	: in std_logic ;
		-- Wishbone signals
        wbs_add     : in std_logic ;
		wbs_readdata  : out std_logic_vector( 15 downto 0);
		wbs_strobe    : in std_logic ;
		wbs_cycle    : in std_logic ;
		wbs_write	  : in std_logic ;
		wbs_ack	      : out std_logic;
		-- irq
		irq : out std_logic ;
		-- fpga input
		button_i 		: in std_logic 
	);
end entity;


---------------------------------------------------------------------------
Architecture button_1 of button is
---------------------------------------------------------------------------
    -- registers mapping
    constant REG_ID     : std_logic := '0';
    constant REG_BUTTON : std_logic := '1';

	signal button_r : std_logic ;
	signal reg : std_logic_vector( 15 downto 0);
begin

	-- connect button
	cbutton : process(gls_clk,gls_reset)
	begin
		if gls_reset = '1' then
			reg <= (others => '0');
		elsif rising_edge(gls_clk) then
			reg <= "000000000000000"&button_i;
		end if;
	end process cbutton;

	-- rise interruption
	pbutton : process(gls_clk,gls_reset)
	begin
		if gls_reset = '1' then
			irq <= '0';
			button_r <= '0';
		elsif rising_edge(gls_clk) then
			if button_r /= button_i then
				irq <= '1';
			else
				irq <= '0';
			end if;
			button_r <= button_i;
		end if;
	end process pbutton;

	-- register reading process
	pread : process(gls_clk,gls_reset)
	begin
		if(gls_reset = '1') then
			wbs_ack <= '0';
			wbs_readdata <= (others => '0');
		elsif(rising_edge(gls_clk)) then
			if(wbs_strobe = '1' and wbs_write = '0' and wbs_cycle = '1')then
    			wbs_ack <= '1';
                if wbs_add = REG_ID then
	    			wbs_readdata <= std_logic_vector(to_unsigned(id,16));
                else
                    wbs_readdata <= reg;
                end if;
            else
                wbs_readdata <= (others => '0');
                wbs_ack <= '0';
            end if;
		end if;
	end process pread;

end architecture button_1;

