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

-- ----------------------------------------------------------------------------
    Entity irq_mngr is
-- ----------------------------------------------------------------------------
    generic
    (
      id : natural := 0;
      irq_count : integer := 16; -- always 16 default
      irq_level : std_logic := '1'
    );
    port
    (
      -- Global Signals
      gls_clk   : in std_logic;
      gls_reset : in std_logic;
      
      -- Wishbone interface signals
      wbs_s1_address    : in  std_logic_vector(1 downto 0);   -- Address bus
      wbs_s1_readdata   : out std_logic_vector(15 downto 0);  -- Data bus for read access
      wbs_s1_writedata  : in  std_logic_vector(15 downto 0);  -- Data bus for write access
      wbs_s1_ack        : out std_logic;                      -- Access acknowledge
      wbs_s1_strobe     : in  std_logic;                      -- Strobe
      wbs_s1_cycle      : in  std_logic ;                     -- Cycle    
      wbs_s1_write      : in  std_logic;                      -- Write access
    
      -- irq from other IP
      irqport        : in  std_logic_vector(irq_count-1 downto 0);
      
      -- Component external signals
      gls_irq           : out std_logic                       -- IRQ request
    );
    end entity;
    
-- ----------------------------------------------------------------------------
    Architecture RTL of irq_mngr is
-- ----------------------------------------------------------------------------

signal irq_r    : std_logic_vector(irq_count-1 downto 0);
signal irq_old  : std_logic_vector(irq_count-1 downto 0);

signal irq_pend : std_logic_vector(irq_count-1 downto 0);
signal irq_ack  : std_logic_vector(irq_count-1 downto 0);

signal irq_mask : std_logic_vector(irq_count-1 downto 0);

signal readdata : std_logic_vector(15 downto 0);
signal rd_ack : std_logic;
signal wr_ack : std_logic;

begin

-- ----------------------------------------------------------------------------
--  External signals synchronization process
-- ----------------------------------------------------------------------------
process(gls_clk, gls_reset)
begin
  if(gls_reset='1') then
    irq_r <= (others => '0');
    irq_old <= (others => '0');
  elsif(rising_edge(gls_clk)) then
    irq_r <= irqport;
    irq_old <= irq_r;
  end if;
end process;

-- ----------------------------------------------------------------------------
--  Interruption requests latching process on rising edge
-- ----------------------------------------------------------------------------
process(gls_clk, gls_reset)
begin
  if(gls_reset='1') then
    irq_pend <= (others => '0');
  elsif(rising_edge(gls_clk)) then
    irq_pend <= (irq_pend or ((irq_r and (not irq_old))and irq_mask)) and (not irq_ack);
  end if;
end process;

-- ----------------------------------------------------------------------------
--  Register reading process
-- ----------------------------------------------------------------------------
process(gls_clk, gls_reset)
begin
  if(gls_reset='1') then
    rd_ack    <= '0';
    readdata  <= (others => '0');
  elsif(rising_edge(gls_clk)) then
    rd_ack  <= '0';
    if(wbs_s1_strobe = '1' and wbs_s1_write = '0' and wbs_s1_cycle = '1') then
      rd_ack  <= '1';
      if(wbs_s1_address = "00") then
        readdata(irq_count-1 downto 0) <= irq_mask;
      elsif(wbs_s1_address="01") then
        readdata(irq_count-1 downto 0) <= irq_pend;
      elsif(wbs_s1_address="10") then
        readdata <= std_logic_vector(to_unsigned(id,16));
      else
        readdata <= (others => '0');
      end if;
    end if;
  end if;
end process;

-- ----------------------------------------------------------------------------
--  Register update process
-- ----------------------------------------------------------------------------
process(gls_clk, gls_reset)
begin
  if(gls_reset='1') then
    irq_ack <= (others => '0');
    wr_ack  <= '0';
    irq_mask <= (others => '0');
  elsif(rising_edge(gls_clk)) then
    irq_ack <= (others => '0');
    wr_ack  <= '0';

    if(wbs_s1_strobe = '1' and wbs_s1_write = '1' and wbs_s1_cycle = '1') then
      wr_ack  <= '1';
      if(wbs_s1_address = "00") then
        irq_mask <= wbs_s1_writedata(irq_count-1 downto 0);
      elsif(wbs_s1_address = "01") then
        irq_ack <= wbs_s1_writedata(irq_count-1 downto 0);
      end if;
    end if;
  end if;
end process;

gls_irq <= irq_level when(unsigned(irq_pend) /= 0 and gls_reset = '0') else
           not irq_level;

wbs_s1_ack <= rd_ack or wr_ack;
wbs_s1_readdata <= readdata when (wbs_s1_strobe = '1' and wbs_s1_write = '0' and wbs_s1_cycle = '1') else (others => '0');

end architecture RTL;
