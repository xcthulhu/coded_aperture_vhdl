-- jpd 1/25/2011
-- Stripped-down, repaired, parameterized version of Armadeus FIFO
-- Removed unimplemented flags
-- data_count now indicates occupancy
-- wr_ack now pulses upon successful write
-- counter widths and memory size reflect addrdepth parameter
-- setting of addrdepth reflects Spartan 3 block memory size

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fifo_syn is
  generic (
    width     : integer := 16;
    addrdepth : integer := 10;
    memdepth  : integer := 1023);         -- Depth of the FIFO: 2^addrdepth-1
  port (
    clk        : in  std_logic;
    din        : in  std_logic_vector(width-1 downto 0);
    rd_en      : in  std_logic;
    reset      : in  std_logic;
    wr_en      : in  std_logic;
    data_count : out std_logic_vector(addrdepth-1 downto 0);
    dout       : out std_logic_vector(width-1 downto 0);
    empty      : out std_logic;
    full       : out std_logic;
    wr_ack     : out std_logic);
end fifo_syn;

architecture fifo_syn_a of fifo_syn is
  subtype wrdtype is std_logic_vector(width-1 downto 0);
  type regtype is array (0 to memdepth) of wrdtype;
  signal reg : regtype;

  signal RdCntr : std_logic_vector(addrdepth-1 downto 0);
  signal WrCntr : std_logic_vector(addrdepth-1 downto 0);
  signal DCntr  : std_logic_vector(addrdepth-1 downto 0);

  signal RW      : std_logic_vector(1 downto 0);
  signal fullxB  : std_logic;
  signal emptyxB : std_logic;
begin
  RW <= rd_en & wr_en;

  seq : process (clk, reset)
  begin  -- process seq
    if reset = '0' then                 -- asynchronous reset (active low)
      RdCntr  <= (others => '0');
      WrCntr  <= (others => '0');
      Dcntr   <= (others => '0');
      emptyxB <= '0';
      fullxB  <= '1';
      wr_ack  <= '0';
    elsif rising_edge(clk) then         -- rising clock edge
      wr_ack <= '0';
      case RW is
        when "00" =>                    -- read and write at the same time
          RdCntr                    <= RdCntr + 1;
          WrCntr                    <= WrCntr + 1;
          wr_ack                    <= '1';
          reg(conv_integer(WrCntr)) <= din;

        when "01" =>                    -- only read
          if (emptyxB = '1') then       -- not empty
            if ((RdCntr +1) = WrCntr) then
              emptyxB <= '0';
            end if;
            RdCntr <= RdCntr + 1;
            DCntr  <= DCntr - 1;
          end if;
          fullxB <= '1';
          wr_ack <= '0';

        when "10" =>                    -- only write
          emptyxB <= '1';
          if fullxB = '1' then          -- not full
            reg(conv_integer(WrCntr)) <= din;
            if WrCntr+1 = RdCntr then
              fullxB <= '0';
            end if;
            WrCntr <= WrCntr +1;
            DCntr  <= DCntr + 1;
            wr_ack <= '1';
          end if;

        when others =>
          wr_ack <= '0';
      end case;
    end if;
  end process seq;

  dout       <= reg(conv_integer(RdCntr));
  full       <= not fullxB;
  empty      <= not emptyxB;
  data_count <= DCntr;

end fifo_syn_a;

