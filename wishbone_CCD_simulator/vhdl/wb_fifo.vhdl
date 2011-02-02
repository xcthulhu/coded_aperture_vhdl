-- wishbone fifo controller

library ieee;
use ieee.std_logic_1164.all;
use work.common_decs.all;

entity wb_fifo is
  generic
    (
      id : device_id := x"0523"
      );
  port
    (
      -- Global Signals
      clk     : in  std_logic;
      reset   : in  std_logic;
      -- Data Input
      din     : in  std_logic_vector(chan_size-1 downto 0);
      -- Write Instruction bit
      wr_en   : in  std_logic;
      -- IRQ System
      irqport : out std_logic;
      -- Wishbone Interaction system
      wbw     : in  wbw;
      wbr     : out wbr
      );
end entity;

architecture RTL of wb_fifo is
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

  signal dout                       : std_logic_vector(chan_size-1 downto 0);
  signal data_count                 : std_logic_vector(addrdepth-1 downto 0);
  signal rd_en, empty, full, wr_ack : std_logic;
  signal half, previous_half        : std_logic := '0';
  signal addr                       : std_logic;
  signal readdata                   : std_logic_vector(chan_size-1 downto 0);
begin
  addr <= wbw.address(wbw.address'low);
  half <= data_count(data_count'high);

  fifo : fifo_syn
    generic map (width     => chan_size,
                 addrdepth => addrdepth)
    port map (
      -- External Signals
      clk        => clk,
      reset      => reset,
      din        => din,
      rd_en      => rd_en,
      -- Internal signals
      wr_en      => wr_en,
      dout       => dout,
      data_count => data_count,
      empty      => empty,
      full       => full,
      wr_ack     => wr_ack
      );

  process (clk)
  begin
    if(rising_edge(clk)) then
      if (half /= previous_half and half = '1') then
        irqport <= '1';
      else
        irqport <= '0';
      end if;
      if (check_wb0(wbw)) then
        case addr is
          when '0' =>
            rd_en    <= '1';
            readdata <= dout;
          when '1' =>
            rd_en    <= '0';
            readdata <= id;
          when others => null;
        end case;
      else
        rd_en <= '0';
      end if;
      previous_half <= half;
    end if;
  end process;
  wbr.ack      <= wbw.cycle;
  wbr.readdata <= readdata;
end architecture;
