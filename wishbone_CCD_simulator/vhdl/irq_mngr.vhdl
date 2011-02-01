-------------------------------------------------------------------------------
--
--  File          :  irq_mnrg.vhd
--  Related files :  (none)
--
--  Author(s)     :  Fabrice Mousset (fabrice.mousset@laposte.net)
--  Project       :  Wishbone Interruption Manager
--
--  Creation Date :  2007/01/05
--
--  Description   :  This is the top file of the IP
-------------------------------------------------------------------------------
--  Modifications :
--  20/10/2008 : Detected rising edge instead of high state
--  Fabien Marteau <fabien.marteau@armadeus.com>
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;

use work.common_decs.all;

entity irq_mngr is
  generic
    (
      id        : device_id := x"1009";
      irq_level : std_logic := '1'
      );
  port
    (
      -- Global Signals
      clk   : in std_logic;
      reset : in std_logic;

      -- Wishbone interface signals
      wbr : out wbr;
      wbw : in  wbw;

      -- irq from other IP
      irqport : in std_logic;

      -- Component external signals
      irq : out std_logic               -- IRQ request
      );
end entity;

-- ----------------------------------------------------------------------------
architecture RTL of irq_mngr is
-- ----------------------------------------------------------------------------

  signal irq_r    : std_logic;
  signal irq_old  : std_logic;
  signal irq_pend : std_logic;
  signal irq_ack  : std_logic;
  signal irq_mask : std_logic;
  signal readdata : std_logic_vector (15 downto 0);
  signal rd_ack   : std_logic;
  signal wr_ack   : std_logic;
  signal addr     : std_logic_vector (1 downto 0);

begin

  addr <= wbw.address(1 downto 0);

-- ----------------------------------------------------------------------------
--  External signals synchronization process
-- ----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if(reset = '1') then
      irq_r   <= '0';
      irq_old <= '0';
    elsif(rising_edge(clk)) then
      irq_r   <= irqport;
      irq_old <= irq_r;
    end if;
  end process;

-- ----------------------------------------------------------------------------
--  Interruption requests latching process on rising edge
-- ----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if(reset = '1') then
      irq_pend <= '0';
    elsif(rising_edge(clk)) then
      irq_pend <= (not irq_ack) and (irq_pend or (irq_r and (not irq_old) and irq_mask));
    end if;
  end process;

-- ----------------------------------------------------------------------------
--  Register reading process
-- ----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if(reset = '1') then
      rd_ack   <= '0';
      readdata <= (others => '0');
    elsif (rising_edge(clk)) then
      rd_ack <= '0';
      if check_wb0(wbw) then
        rd_ack <= '1';
        case addr is
          when "00"   => readdata <= (0 => irq_mask, others => '0');
          when "01"   => readdata <= (0 => irq_pend, others => '0');
          when "10"   => readdata    <= ext(id, readdata'length);
          when "11"   => readdata    <= (others => '0');
          when others => null;
        end case;
      else
        readdata <= (others => '0');
      end if;
    end if;
  end process;

-- ----------------------------------------------------------------------------
--  Register update process
-- ----------------------------------------------------------------------------
  process(clk, reset)
  begin
    if (reset = '1') then
      irq_ack  <= '0';
      wr_ack   <= '0';
      irq_mask <= '0';
    elsif (rising_edge(clk)) then
      irq_ack <= '0';
      wr_ack  <= '0';
      if check_wb1(wbw) then
        wr_ack <= '1';
        case addr is
          when "00"   => irq_mask <= wbw.writedata(0);
          when "01"   => irq_ack  <= wbw.writedata(0);
          when others => null;
        end case;
      end if;
    end if;
  end process;

  irq <= irq_level when (irq_pend /= '0' and reset = '0') else not irq_level;

  wbr.ack      <= rd_ack or wr_ack;
  wbr.readdata <= readdata;

end architecture RTL;
