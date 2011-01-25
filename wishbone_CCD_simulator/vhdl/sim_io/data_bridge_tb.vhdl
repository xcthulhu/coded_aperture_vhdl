library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

--  A testbench has no ports.
entity data_bridge_tb is end data_bridge_tb;

architecture behav of data_bridge_tb is
  component data_bridge is
    port (
      clk, STROBE : in std_logic ;
      irqport : out std_logic ;
      a, b : in  std_logic_vector(7 downto 0);
      wbr : out wbr;
      wbw : in wbw);
  end component;
  --  Specifies which entity is bound to the component
  for dut : data_bridge use entity work.data_bridge;
  signal clk, STROBE, irqport : std_logic;
  signal wbw : wbw;
  signal a, b : std_logic_vector(7 downto 0);
  signal wbr : wbr;

begin
  dut : data_bridge
    port map ( clk => clk
             , STROBE => STROBE
             , irqport => irqport
             , wbr => wbr
             , wbw => wbw
             , a => a
             , b => b
             );
  process
    -- These control the looping we will do
    constant the_end : integer := 10000;
    variable count   : integer;
  begin
    clk <= '0';
    STROBE <= '0';
    wbw.strobe <= '0';
    wbw.cycle <= '0';
    wbw.writing <= '0';
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
end;
