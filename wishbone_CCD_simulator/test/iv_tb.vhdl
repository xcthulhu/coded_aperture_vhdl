library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

library C;
use C.stdio_h.all;

library CCD;
use CCD.common_decs.all;

use work.common_decs.all;

--  A testbench has no ports
entity iv_tb is end;

architecture behav of iv_tb is
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

  constant addrdepth : integer := 10;
  component fifo_syn is
    generic (
      width     : integer := chan_size;
      addrdepth : integer := addrdepth);
    port (
      clk, reset          : in  std_logic;
      din                 : in  std_logic_vector(width-1 downto 0);
      rd_en, wr_en        : in  std_logic;
      dout                : out std_logic_vector(width-1 downto 0);
      data_count          : out std_logic_vector(addrdepth-1 downto 0);
      empty, full, wr_ack : out std_logic);
  end component;

  component rstgen_syscon is
    port (
      clk  : in  std_logic;
      sysc : out syscon
      );
  end component;


  for dut1 : sclk_data_acq use entity CCD.sclk_data_acq;
  for dut2 : data_bridge use entity CCD.data_bridge;
  for dut3 : fifo_syn use entity CCD.fifo_syn;
  for dut4 : rstgen_syscon use entity CCD.rstgen_syscon;


  signal sysc : syscon;
  signal clk  : std_logic := '0';
  -- Signals from file
  signal SCLK, a_in,
    b_in, STROBE : std_logic;
  -- Bridge Signals
  signal a          : std_logic_vector(7 downto 0)           := (others => '0');
  signal b          : std_logic_vector(7 downto 0)           := (others => '0');
  signal bridge_out : std_logic_vector(chan_size-1 downto 0) := (others => '0');
  -- Fifo Signals
  signal wr_en, rd_en, empty,
    full, wr_ack : std_logic := '0';
  signal dout       : std_logic_vector(chan_size-1 downto 0);
  signal data_count : std_logic_vector(addrdepth-1 downto 0);

begin
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

  dut3 : fifo_syn
    generic map (width     => chan_size,
                 addrdepth => addrdepth)
    port map (clk        => sysc.clk,
              reset      => sysc.reset,
              din        => bridge_out,
              rd_en      => rd_en,
              wr_en      => wr_en,
              dout       => dout,
              data_count => data_count,
              empty      => empty,
              full       => full,
              wr_ack     => wr_ack
              );

  dut4 : rstgen_syscon
    port map (clk  => clk,
              sysc => sysc
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
