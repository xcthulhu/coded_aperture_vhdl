library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity data_wbs_bridge is
  port (
    -- Global clock
    clk                    : in  std_logic
    -- Strobe clock from physical pin on board
  ; STROBE                 : in  std_logic
    -- Data Input
  ; a, b                   : in  std_logic_vector(7 downto 0)
    -- IRQ Flag
  ; irq                    : out std_logic
    -- Wishbone Signals
  ; wbs_strobe, wbs_cycle, 
    wbs_write              : in  std_logic
  ; wbs_readdata           : out std_logic_vector(15 downto 0)
  ; wbs_ack                : out std_logic
    );
end data_wbs_bridge;

architecture data_wbs_bridge_1 of data_wbs_bridge is
  -- Previous state of the STROBE pin according to the clk
  signal previous_STROBE : std_logic := STROBE;
begin
  strobe_emit : process(clk)
  begin
    if (rising_edge(clk)) then
      if (STROBE /= previous_STROBE) then  -- If change in STROBE value
        irq             <= '1';            -- throw interupt
        previous_STROBE <= STROBE;
      else
        irq <= '0';                        -- ...otherwise make interupt quiet
      end if;
    end if;
  end process strobe_emit;

  wb_handshake : process(clk)
  begin
    if (rising_edge(clk)) then
      if(wbs_strobe = '1' and wbs_write = '0' and wbs_cycle = '1') then
        -- If wishbone is ready, dump data
        wbs_ack      <= '1';
        wbs_readdata <= a & b;
      else
        -- Otherwise remain quiet
        wbs_ack      <= '0';
        wbs_readdata <= (others => '0');
      end if;
    end if;
  end process wb_handshake;
end data_wbs_bridge_1;
