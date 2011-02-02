-- A module containing the chain
-- sysclk_data_acq -> data_bridge -> wb_fifo

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity wb_fifo_chain is
  generic (id : device_id := x"0523");
  port
    (
      -- External Clock
      sysc       : in  syscon;
      -- External pins
      a_in, b_in : in  std_logic;
      SCLK       : in  std_logic;
      STROBE     : in  std_logic;
      -- IRQ System
      irqport    : out std_logic;
      -- Wishbone Interaction system
      wbw        : in  wbws;
      wbr        : out wbrs
      );
end entity;

architecture RTL of wb_fifo_chain is
  -- Components
  component wb_fifo is
    generic
      (id : device_id := id);
    port
      (
        sysc    : in  syscon;
        wr_en   : in  std_logic;
        din     : in  std_logic_vector(chan_size-1 downto 0);
        irqport : out std_logic;
        wbw     : in  wbws;
        wbr     : out wbrs
        );
  end component;

  component data_bridge
    port (
      sysc   : in  syscon;
      STROBE : in  std_logic;
      a, b   : in  std_logic_vector(7 downto 0);
      wr_en  : out std_logic := '0';
      dout   : out std_logic_vector(15 downto 0)
      );
  end component;

  component sclk_data_acq is
    port (
      sysc       : in  syscon;
      a_in, b_in : in  std_logic;
      a, b       : out std_logic_vector (7 downto 0)
      );
  end component;

  -- Signals
  ---- Data vectors
  signal a, b       : std_logic_vector (7 downto 0);
  signal bridge_out : std_logic_vector(chan_size-1 downto 0);
  ---- Write Instruction for FIFO
  signal wr_en      : std_logic;

begin

  wb_fifo00 : wb_fifo
    generic map (id => id)
    port map (
      sysc    => sysc,
      irqport => irqport,
      din     => bridge_out,
      wr_en   => wr_en,
      wbw     => wbw,
      wbr     => wbr
      );

  bridge : data_bridge
    port map (
      sysc   => sysc,
      STROBE => STROBE,
      a      => a,
      b      => b,
      dout   => bridge_out,
      wr_en  => wr_en
      );

  data_acq : sclk_data_acq
    port map (
      sysc => sysc,
      a_in => a_in,
      b_in => b_in,
      a    => a,
      b    => b
      );

end architecture;
