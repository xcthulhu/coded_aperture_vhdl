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
      sysc    : in  syscon;
      -- Data Input
      din     : in  read_chan;
      -- Write Instruction bit
      wr_en   : in  std_logic;
      -- IRQ System
      irqport : out irq_port;
      -- Wishbone Interaction system
      wbw     : in  wbws;
      wbr     : out wbrs
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

  signal dout       : read_chan;
  signal data_count : std_logic_vector(addrdepth-1 downto 0);
  signal rd_en, empty,
    full, wr_ack : std_logic;
  signal half     : std_logic;
  signal addr     : std_logic_vector(1 downto 0);
  signal readdata : read_chan;
begin
  addr <= wbw.address(1 downto 0);
  half <= data_count(data_count'high);

  fifo : fifo_syn
    generic map (width     => chan_size,
                 addrdepth => addrdepth)
    port map (
      -- External Signals
      clk        => sysc.clk,
      reset      => sysc.reset,
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

  process (sysc.clk)
    variable previous_half : std_logic := '1';
  begin
    if(rising_edge(sysc.clk)) then
      if (half /= previous_half and half = '1') then
        irqport <= (0 => '1', others => '0');
      else
        irqport <= (others => '0');
      end if;
      if (check_wb0(wbw)) then
        case addr is
          when "10" =>                  -- Read data
            rd_en    <= '1';
            readdata <= dout;
          when "01" =>                  -- Report whether empty
            rd_en    <= '0';
            readdata <= (readdata'low => empty, others => '0');
          when "00" =>                  -- ID
            rd_en    <= '0';
            readdata <= id;
          when "11" =>                  -- ID
            rd_en    <= '0';
            readdata <= (others => '0');
          when others => null;
        end case;
      else
        rd_en <= '0';
      end if;
      previous_half := half;
    end if;
  end process;
  wbr.ack      <= wbw.cycle;  -- Always put an ack or you hang the bus
  wbr.readdata <= readdata;
end architecture;
