---------------------------------------------------------------------------
-- Company     : ARMadeus Systems
-- Author(s)   : Fabien Marteau
-- 
-- Creation Date : 05/03/2008
-- File          : led.vhd
--
-- Abstract : drive one led with Wishbone bus
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-----------------------------------------------------------------------
    Entity led is 
-----------------------------------------------------------------------
    generic(
        id : natural := 1;
        wb_size : natural := 16 -- Data port size for wishbone
    );
    port 
    (
        -- Syscon signals
        gls_reset    : in std_logic ;
        gls_clk      : in std_logic ;
        -- Wishbone signals
        wbs_add       : in std_logic ;
        wbs_writedata : in std_logic_vector( wb_size-1 downto 0);
        wbs_readdata  : out std_logic_vector( wb_size-1 downto 0);
        wbs_strobe    : in std_logic ;
        wbs_cycle      : in std_logic ;
        wbs_write     : in std_logic ;
        wbs_ack       : out std_logic;
        -- out signals
        led_o : out std_logic 
    );
end entity led;


-----------------------------------------------------------------------
Architecture led_1 of led is
-----------------------------------------------------------------------
    -- registers mapping
    constant REG_LED : std_logic := '0';
    constant REG_ID  : std_logic := '1';

    signal reg : std_logic_vector( wb_size-1 downto 0);
    signal read_ack : std_logic ;
    signal write_ack : std_logic ;
begin

-- connect led_o
led_o <= reg(0);

wbs_ack <= read_ack or write_ack;

-- manage register
write_bloc : process(gls_clk,gls_reset)
begin
    if gls_reset = '1' then 
        reg <= (others => '0');
        write_ack <= '0';
    elsif rising_edge(gls_clk) then
        if ((wbs_strobe and wbs_write and wbs_cycle) = '1' ) then
            reg <= wbs_writedata;
            write_ack <= '1';
        else
            write_ack <= '0';
        end if;
    end if;

end process write_bloc;

read_bloc : process(gls_clk, gls_reset)
begin
    if gls_reset = '1' then
        wbs_readdata <= (others => '0');
    elsif rising_edge(gls_clk) then
        if (wbs_strobe = '1' and wbs_write = '0'  and wbs_cycle = '1' ) then
            read_ack <= '1';
            if wbs_add = REG_LED then
                wbs_readdata <= reg;
            else
                wbs_readdata <= std_logic_vector(to_unsigned(id,wb_size));
            end if;
        else
            wbs_readdata <= (others => '0');
            read_ack <= '0';
        end if;
    end if;
end process read_bloc;

end architecture led_1;

