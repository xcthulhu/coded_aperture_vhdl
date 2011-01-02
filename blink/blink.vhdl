library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.numeric_std.all;
 
 entity Clk_div_led is
    Generic ( max_count : natural := 33000000 ) ;
    Port ( CLK_33MHZ_FPGA  : in  std_logic
         ; GPIO_LED_0      : out std_logic
         );
 end Clk_div_led;
 
 architecture RTL of Clk_div_led is
   signal Rst_n : std_logic;
 begin
 
    Rst_n <= '1';
 
    -- compteur de 0 à max_count
    compteur : process(CLK_33MHZ_FPGA, Rst_n)
        variable count : natural range 0 to max_count;
    begin
        if Rst_n = '0' then
            count := 0;
            GPIO_LED_0 <= '1';
        elsif rising_edge(CLK_33MHZ_FPGA) then
            if count < max_count/2 then
                GPIO_LED_0 <= '1';
                count := count + 1;
            elsif count < max_count then
                GPIO_LED_0 <= '0';
                count := count + 1;
            else
                count := 0;
                GPIO_LED_0 <= '1';
            end if;
        end if;
    end process compteur; 
 end RTL;
