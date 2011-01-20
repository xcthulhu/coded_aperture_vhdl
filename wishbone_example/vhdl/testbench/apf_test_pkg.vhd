----------------------------------------------
-- Design Name : Test bench utils
-- File Name : apf_test_pkg.vhd
-- Function : Defines communication functions between imx and fpga
-- Author   : Fabien Marteau <fabien.marteau@armadeus.com>
-- Version  : 1.00
---------------------------------------------
-----------------------------------------------------------------------------------
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2, or (at your option)
-- any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

package apf_test_pkg is
    -- write procedures
    -- Params :
    --    address      : Write address 
    --    value        : value to write 
    --    gls_clk      : clock signal
    --    imx_cs_n     : Chip select 
    --    imx_oe_n     : Read signal
    --    imx_eb3_n    : Write signal
    --    imx_address  : Address signal
    --    imx_data     : Data signal
    --    WSC          : Value of imx WSC (see MC9328MXLRM.pdf p169) for sync=0
 
    procedure imx_write(
    address     : in std_logic_vector (15 downto 0);
    value       : in std_logic_vector (15 downto 0);
    signal   gls_clk     : in std_logic ;
    signal   imx_cs_n    : out std_logic ;
    signal   imx_oe_n    : out std_logic ;
    signal   imx_eb3_n   : out std_logic ;
    signal   imx_address : out std_logic_vector (12 downto 1);
    signal   imx_data    : out std_logic_vector (15 downto 0);
    WSC         : natural
);
    -- read procedures
    -- Params :
    --    address      : Write address 
    --    value        : value returned
    --    gls_clk      : clock signal
    --    imx_cs_n     : Chip select 
    --    imx_oe_n     : Read signal
    --    imx_eb3_n    : Write signal
    --    imx_address  : Address signal
    --    imx_data     : Data signal
    --    WSC          : Value of imx WSC (see MC9328MXLRM.pdf p169) for sync=0
 
procedure imx_read(
    address     : in std_logic_vector (15 downto 0);
    signal   value       : out std_logic_vector (15 downto 0);
    signal   gls_clk     : in std_logic ;
    signal   imx_cs_n    : out std_logic ;
    signal   imx_oe_n    : out std_logic ;
    signal   imx_eb3_n   : out std_logic ;
    signal   imx_address : out std_logic_vector (12 downto 1);
    signal   imx_data    : in std_logic_vector (15 downto 0);
    WSC         : natural
   );


end package apf_test_pkg;

package body apf_test_pkg is
    
    -- Write value from imx
       
    procedure imx_write(
    address     : in std_logic_vector (15 downto 0);
    value       : in std_logic_vector (15 downto 0);
    signal   gls_clk     : in std_logic ;
    signal   imx_cs_n    : out std_logic ;
    signal   imx_oe_n    : out std_logic ;
    signal   imx_eb3_n   : out std_logic ;
    signal   imx_address : out std_logic_vector (12 downto 1);
    signal   imx_data    : out std_logic_vector (15 downto 0);
    WSC         : natural
) is
begin
    -- Write value
    wait until falling_edge(gls_clk);
    wait for 4 ns;
    imx_address <= address(12 downto 1);
    imx_cs_n <= '0';
    imx_eb3_n <= '0';
    wait until falling_edge(gls_clk);
    wait for 2500 ps;
    imx_data  <= value;
    if WSC <= 1 then
        wait until falling_edge(gls_clk);
    else
        for n in 1 to WSC loop
            wait until falling_edge(gls_clk); -- WSC = 2 
        end loop;
    end if;
    wait for 1 ns;
    imx_cs_n <= '1';
    imx_eb3_n <= '1';
    imx_address <= (others => 'Z');
    imx_data  <= (others => 'Z');
end procedure imx_write;

-- Read a value from imx
procedure imx_read(
    address     : in std_logic_vector (15 downto 0);
    signal   value       : out std_logic_vector (15 downto 0);
    signal   gls_clk     : in std_logic ;
    signal   imx_cs_n    : out std_logic ;
    signal   imx_oe_n    : out std_logic ;
    signal   imx_eb3_n   : out std_logic ;
    signal   imx_address : out std_logic_vector (12 downto 1);
    signal   imx_data    : in std_logic_vector (15 downto 0);
    WSC :  natural
) is
begin
    -- Read value
    wait until falling_edge(gls_clk);
    wait for 4 ns;
    imx_address <= address(12 downto 1);
    imx_cs_n <= '0';
    imx_oe_n <= '0';
    if WSC <= 1 then
        wait until falling_edge(gls_clk);
    else
        for n in 1 to WSC loop
            wait until falling_edge(gls_clk); 
        end loop;
    end if;
    wait until falling_edge(gls_clk);
    value <= imx_data;
    imx_cs_n <= '1';
    imx_oe_n <= '1';
    imx_address <= (others => 'Z');
    wait for 20 ns;
end procedure imx_read;

end package body apf_test_pkg;
