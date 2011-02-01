library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity intercon is
    port
    (
        -- Global Signals
        clk : in std_logic;
        reset : in std_logic;

        -- Wishbone Wrapper
        wbr : out wbr;
        wbw : in wbw;
        wrapper_clk : out std_logic;
        wrapper_reset : out std_logic;
        
        -- IRQ signals
        irq_wbr : in wbr;
        irq_wbw : out wbw;
        irq_clk : out std_logic;
        irq_reset : out std_logic;
       
        -- FIFO signals
        fifo_wbr : in wbr;
        fifo_wbw : out wbw;
        fifo_clk : out std_logic;
        fifo_reset : out std_logic
        );
end entity intercon;

architecture intercon of intercon is
    constant topb : integer := 12;
    constant botb : integer := 7;
    subtype topsix is std_logic_vector(topb downto botb);
    constant irqa : topsix := "000000" ;
    constant fifoa : topsix := "000001" ;
    
    function is_slctd(my_wbw : wbw, addr : topsix) return boolean is
    begin return(wbw.address(topb downto botb) = addr); end;
    
    signal dead : wbr;
    
begin

-- Clock and reset distribution. Maybe this doesn't belong here.
    wrapper_clk <= clk;
    irq_clk <= clk;
    fifo_clk <= clk;
    wrapper_reset <= reset;
    irq_reset <= reset;
    fifo_reset <= reset;
    
-- Most data signals to slaves may be routed to all slaves, need no gating.
    irq_wbw <= wbw;
    fifo_wbw <= wbw;
    
-- Gate strobe to slaves.
    irq_wbw.cycle <= wbw.cycle when is_slctd(wbw, irqa) else '0';
    fifo_wbw.cycle <= wbw.cycle when is_slctd(wbw, fifoa) else '0';

-- Multiplex data and ack from slaves.
-- Respond with 0xdead if no slave selected.
    dead.ack <= wbw.cycle;
    dead.readdata <= '1101111010101101';
    wbr <= irq_wbr when is_slctd(wbw, irqa) else
        fifo_wbr when is_slctd(wbw, fifoa) else
        dead;

end architecture intercon;
