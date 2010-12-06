library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.numeric_std.all;

--  A testbench has no ports.
entity blink_tb is end blink_tb;

architecture behav of blink_tb is
   component Clk_div_led is
       Generic ( max_count : natural := 33000000 ) ;
       Port ( CLK_33MHZ_FPGA : in std_logic ; GPIO_LED_0 : out std_logic );
   end component;
   --  Specifies which entity is bound with the component.
   for uut : Clk_div_led use entity work.Clk_div_led ;
   signal GPIO_LED_0 : std_logic ;
   signal CLK_33MHZ_FPGA : std_logic ;
begin
   --  Component instantiation.
   uut : Clk_div_led generic map ( max_count => 1000000) 
                     port map (CLK_33MHZ_FPGA => CLK_33MHZ_FPGA, 
                               GPIO_LED_0 => GPIO_LED_0) ;
   process
   begin
      CLK_33MHZ_FPGA <= '1';
      loop
	  wait for 15 ns;
          CLK_33MHZ_FPGA <= not CLK_33MHZ_FPGA;
          wait for 15 ns;
      end loop ;
      wait ; 
   end process ; 
end behav ;
