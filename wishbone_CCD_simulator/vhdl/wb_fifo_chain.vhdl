-- A module containing the chain
-- sysclk_data_acq -> data_bridge -> wb_fifo

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.common_decs.all;

entity wb_fifo_chain is
  generic (
	id : device_id := x"0523";
	addrdepth : integer := 10
	);
  port
    (
      -- External Clock
      sysc       : in  syscon;
      -- External pins
      a_in, b_in : in  std_logic;
      SCLK       : in  std_logic;
      STROBE     : in  std_logic;
      -- IRQ System
      irqport    : out irq_port;
      -- Wishbone Interaction system
      wbw        : in  wbws;
      wbr        : out wbrs
      );
end entity;

architecture RTL of wb_fifo_chain is
  -- Components
  component wb_fifo is
    generic
      (id : device_id := id;
	addrdepth : integer := 10
 	);
    port
      (
        sysc    : in  syscon;
        wr_en   : in  std_logic;
        din     : in  read_chan;
        irqport : out irq_port;
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
      dout   : out read_chan
      );
  end component;

  component sclk_data_acq is
    port (
      sysc             : in  syscon;
      SCLK, a_in, b_in : in  std_logic;
      a, b             : out std_logic_vector (7 downto 0)
      );
  end component;

  -- Signals
  ---- Data vectorss
  signal a, b       : std_logic_vector (7 downto 0);
  signal bridge_out : read_chan;
  ---- Write Instruction for FIFO
  signal wr_en      : std_logic;

begin

  wb_fifo00 : wb_fifo
    generic map (
	id => id,
	addrdepth => addrdepth 
	)
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
      SCLK => SCLK,
      a_in => a_in,
      b_in => b_in,
      a    => a,
      b    => b
      );

end architecture;
