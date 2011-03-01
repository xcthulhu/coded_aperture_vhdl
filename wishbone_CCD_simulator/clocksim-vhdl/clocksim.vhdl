library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library unisim;
use unisim.Vcomponents.all;

use work.clocksim_decs.all;

entity clocksim is
  generic (div : natural := 100);
  port (CLK            : in  std_logic;
        SCLK_anode     : out std_logic;
        SCLK_cathode   : out std_logic;
        STROBE_anode   : out std_logic;
        STROBE_cathode : out std_logic;
        A_anode        : out std_logic;
        A_cathode      : out std_logic;
        B_anode        : out std_logic;
        B_cathode      : out std_logic);
end;

architecture RTL of clocksim is
  signal n_SCLK, SCLK, STROBE, A, B : std_logic;
  signal state                      : sig := (others => '0');
begin
  -- XILINX OUTPUT
  n_SCLK <= not SCLK;

  SCLK_LVDS_OUT : OBUFDS
    port map (I  => n_SCLK,
              O  => SCLK_anode,
              OB => SCLK_cathode);

  STROBE_LVDS_OUT : OBUFDS
    port map (I  => STROBE,
              O  => STROBE_anode,
              OB => STROBE_cathode);

  A_LVDS_OUT : OBUFDS
    port map (I  => A,
              O  => A_anode,
              OB => A_cathode);

  B_LVDS_OUT : OBUFDS
    port map (I  => B,
              O  => B_anode,
              OB => B_cathode);

  -- Set SCLK behavior
  sclocker : process(Clk)
    variable i : natural range 0 to div := 0;
  begin
    if (rising_edge(Clk)) then
      if i < div then
        i    := i + 1;
        SCLK <= '0';
      else
        i    := 0;
        SCLK <= '1';
      end if;
    end if;
  end process;

  -- Set Strobe behavior
  strober : process(SCLK)
    constant freq : natural                 := 7;
    variable i    : natural range 0 to freq := 0;
  begin
    if (rising_edge(SCLK)) then
      if i < freq then
        i      := i + 1;
        STROBE <= '0';
      else
        i      := 0;
        STROBE <= '1';
      end if;
    end if;
  end process;

  -- Set A and B behavior based on state
  A_and_B : process(SCLK)
    variable bit : natural range 0 to 7 := 7;
  begin
    if (rising_edge(SCLK)) then
      A <= state(bit);
      B <= state(bit+8);
      if (bit = 0) then
        bit := 7;
      else
        bit := bit - 1;
      end if;
    end if;
  end process;

  -- Use a stack machine to determine state behavior
  state_proc : process(SCLK)
    variable stack               : MODE_STACK                      := (others => FRAME);
    variable idx                 : natural range 0 to STACK_SIZE-1 := 0;
    variable ft, row_down        : std_logic                       := '0';
    variable down_pixel          : natural range 0 to 2            := 0;
    variable pixel_step, pm_step : natural range 0 to 7            := 0;
    variable frame_downs, readout_rows,
      row_pixels : natural range 0 to 1280 := 0;
  begin
    if (rising_edge(SCLK)) then
      case stack(idx) is
        when FRAME =>
          if (frame_downs < 1280) then
            ft          := '1';
            idx         := idx + 1;
            stack(idx)  := DOWN;
            frame_downs := frame_downs + 1;
          else
            state(P2VI) <= '0';
            frame_downs := 0;
            idx         := 0;
            stack(idx)  := READOUT;
          end if;
          
        when READOUT =>
          if (readout_rows < 1280) then
            idx          := idx + 1;
            stack(idx)   := ROW;
            readout_rows := readout_rows + 1;
          else
            frame_downs := 0;
            idx         := 0;
            stack(idx)  := FRAME;
          end if;
          
        when ROW =>
          if (row_down = '0') then
            ft         := '0';
            idx        := idx + 1;
            stack(idx) := DOWN;
            row_down   := '1';
          elsif (row_pixels < 1280) then
            idx        := idx + 1;
            stack(idx) := PIXEL;
            row_pixels := row_pixels + 1;
          else
            row_pixels := 0;
            row_down   := '0';
            idx        := idx - 1;
          end if;
          
        when DOWN =>
          case down_pixel is
            when 0 =>
              state(P1VI) <= '1';
              state(P1VS) <= '1';
              state(P2VI) <= '0';
              state(P2VS) <= '0';
              state(TG)   <= '0';
              idx         := idx + 1;
              stack(idx)  := PIXEL_MAYBE;
              down_pixel  := 1;
            when 1 =>
              state(P1VI) <= '0';
              state(P1VS) <= '0';
              state(P2VI) <= '1';
              state(P2VS) <= '1';
              state(TG)   <= '1';
              idx         := idx + 1;
              stack(idx)  := PIXEL_MAYBE;
              down_pixel  := 2;
            when 2 =>
              idx        := idx - 1;
              down_pixel := 0;
            when others => null;
          end case;
          
        when PIXEL_MAYBE =>
          if (pm_step /= 7) then
            if (ft = '1') then
              idx        := idx + 1;
              stack(idx) := PIXEL;
              pm_step    := 7;
            else
              pm_step := pm_step + 1;
            end if;
          else
            idx     := idx - 1;
            pm_step := 0;
          end if;
          
        when PIXEL =>
          case pixel_step is
            when 0 =>
              state(P1H)    <= '1';
              state(P2A4BH) <= '1';
              state(P4A2BH) <= '1';
              state(P3H)    <= '0';
              state(P2C4DH) <= '0';
              state(P4C2DH) <= '0';
              state(SG)     <= '0';
              pixel_step    := pixel_step + 1;
            when 5 =>
              state(P1H)    <= '0';
              state(P2A4BH) <= '0';
              state(P4A2BH) <= '0';
              state(P3H)    <= '1';
              state(P2C4DH) <= '1';
              state(P4C2DH) <= '1';
              state(SG)     <= '1';
              pixel_step    := pixel_step + 1;
            when 1 | 2 | 3 | 4 | 6 =>
              pixel_step := pixel_step + 1;
            when 7 =>
              pixel_step := 0;
              idx        := idx - 1;
            when others => null;
          end case;
        when others => null;
      end case;
    end if;
  end process;
end;
