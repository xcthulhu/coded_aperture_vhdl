library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity intercon is
    port
    (
        wrapper_wbr : out wbr;
        wrapper_wbw : in wbw;
        wrapper_clk : out std_logic;
        wrapper_reset : out std_logic;
        
        irq_wbr : in wbr;
        irq_wbw : out wbw;
        irq_clk : out std_logic;
        irq_reset : out std_logic;
       
        fifo_wbr : in wbr;
        fifo_wbw : out wbw;
        fifo_clk : out std_logic;
        fifo_reset : out std_logic;
