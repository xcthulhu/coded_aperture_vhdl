library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

library C;
use C.stdio_h.all;

library CCD;
use CCD.common_decs.all;

use work.common_decs.all;

--  A testbench has no ports
entity ii_tb is end;

architecture behav of ii_tb is
  component sclk_data_acq is
    port (
      sysc             : in  syscon;
      SCLK, a_in, b_in : in  std_logic;
      a, b             : out std_logic_vector(7 downto 0)
      );
  end component;

  component data_bridge is
    port (
      sysc   : in  syscon;
      STROBE : in  std_logic;
      a, b   : in  std_logic_vector(7 downto 0);
      wr_en  : out std_logic;
      dout   : out std_logic_vector(15 downto 0)
      );
  end component;

  for dut1          : sclk_data_acq use entity CCD.sclk_data_acq;
  for dut2          : data_bridge use entity CCD.data_bridge;
  signal clk, reset : std_logic := '0';
  signal sysc       : syscon;
  signal SCLK, a_in,
    b_in, STROBE, wr_en : std_logic;
  signal a          : std_logic_vector(7 downto 0)           := (others => '0');
  signal b          : std_logic_vector(7 downto 0)           := (others => '0');
  signal bridge_out : std_logic_vector(chan_size-1 downto 0) := (others => '0');
begin
  sysc.clk   <= clk;
  sysc.reset <= reset;

  dut1 : sclk_data_acq
    port map (sysc => sysc,
              SCLK => SCLK,
              a_in => a_in,
              b_in => b_in,
              a    => a,
              b    => b
              );

  dut2 : data_bridge
    port map (
      sysc   => sysc,
      STROBE => STROBE,
      a      => a,
      b      => b,
      dout   => bridge_out,
      wr_en  => wr_en
      );

  process
    variable fin                          : CFILE   := fopen("clocksim.dat", "r");
    variable sclkv, a_inv, b_inv, strobev : integer;
    variable n                            : integer := 0;
    constant rate                         : integer := 8;
  begin
    while (not(feof(fin))) loop
      if (n = 0) then
        -- Get values from file
        fscanf(fin, "%d", sclkv);
        fscanf(fin, "%d", a_inv);
        fscanf(fin, "%d", b_inv);
        fscanf(fin, "%d\n", strobev);

        -- Assign values to signals
        SCLK   <= int_to_bit(sclkv);
        a_in   <= int_to_bit(a_inv);
        b_in   <= int_to_bit(b_inv);
        STROBE <= int_to_bit(strobev);

        -- Print values
        printf("%d ", sclkv);
        printf("%d ", a_inv);
        printf("%d ", b_inv);
        printf("%d\n", strobev);
      end if;
      n   := (n + 1) mod rate;
      wait for 1 ns;
      clk <= not clk;
    end loop;
    fclose(fin);
    wait;
  end process;
end;
