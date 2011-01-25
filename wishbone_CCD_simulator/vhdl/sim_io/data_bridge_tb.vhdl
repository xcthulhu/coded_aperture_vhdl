library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--  A testbench has no ports.
entity data_wbs_bridge_tb is end data_wbs_bridge_tb;

architecture behav of data_wbs_bridge_tb is
  component data_wbs_bridge is
    port (
      clk, STROBE, wbs_strobe, wbs_cycle,
      wbs_write : in std_logic
    ; irq, wbs_ack : out std_logic
    ; a, b : in  std_logic_vector(7 downto 0)
    ; wbs_readdata : out std_logic_vector(15 downto 0) );
  end component;
  --  Specifies which entity is bound to the component
  for dut : data_wbs_bridge use entity work.data_wbs_bridge;
  signal clk, STROBE, irq, wbs_strobe,
         wbs_cycle, wbs_write,
         wbs_ack : std_logic;
  signal a, b : std_logic_vector(7 downto 0);
  signal wbs_readdata : std_logic_vector(15 downto 0);

begin
  dut : data_wbs_bridge
    port map ( clk => clk
             , STROBE => STROBE
             , irq => irq
             , wbs_readdata => wbs_readdata
             , wbs_strobe => wbs_strobe
             , wbs_cycle => wbs_cycle
             , wbs_write => wbs_write
             , wbs_ack => wbs_ack
             , a => a
             , b => b );
  process
    -- These control the looping we will do
    constant the_end : integer := 10000;
    variable count   : integer;
  begin
    clk <= '0';
    STROBE <= '0';
    wbs_strobe <= '0';
    wbs_cycle <= '0';
    wbs_write <= '0';
    a <= (others => '0');
    b <= (others => '0');
    for count in 0 to the_end loop
      wait for 2 ns;
      clk <= not clk;
      if ((count mod 8) = 0) then
        STROBE <= not STROBE;
      end if;
    end loop;
    wait;
  end process;
end behav;
