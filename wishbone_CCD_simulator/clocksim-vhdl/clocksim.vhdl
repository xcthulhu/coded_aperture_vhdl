library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

use work.clocksim_decs.all;
use work.common_decs.all;

entity clocksim is
  generic (div : natural := 100);
  port (sysc               : in  syscon;
        SCLK, STROBE, A, B : out std_logic);
end;

architecture RTL of clocksim is
  signal iSCLK : std_logic;
  signal state : sig := (others => '0');
  signal bit : natural range 0 to 7;
  variable mode : string(1 to 20);
begin
  -- Connect external to internal signals
  SCLK <= iSCLK;
  A <= state(bit);
  B <= state(bit+8);

  -- Set SCLK behavior
  sclocker : process(sysc.reset, sysc.clk)
    constant freq : natural := 15;
    variable i    : natural range 0 to div;
  begin
    if (sysc.reset = '1') then
      iSCLK <= '0';
      i     := 0;
    elsif (rising_edge(sysc.clk)) then
      if i < div then
        i := i + 1;
      else
        i     := 0;
        iSCLK <= not iSCLK;
      end if;
    end if;
  end process;

  -- Set Strobe behavior
  strober : process(sysc.reset, iSCLK)
    constant freq : natural := 14;
    variable i    : natural range 0 to freq;
  begin
    if (sysc.reset = '1') then
      STROBE <= '1';
      i      := 0;
    elsif (iSCLK'event) then
      if i < freq then
        i      := i + 1;
        STROBE <= '1';
      else
        i      := 0;
        STROBE <= '0';
      end if;
    end if;
  end process;

  -- Serialize state using A and B
  A_and_B : process(sysc.reset, iSCLK)
  begin
    if (sysc.reset = '1') then
      bit <= 7;
    elsif (falling_edge(iSCLK)) then
      if (bit = 0) then bit <= 7;
      else bit <= bit - 1;
      end if;
    end if;
  end process;

  -- Use a stack machine to determine state behavior
  state_proc : process(sysc.reset, iSCLK)
    variable stack        : MODE_STACK := (others => FRAME);
    variable idx          : natural range 0 to STACK_SIZE-1;
    variable ft, row_down : std_logic;
    variable down_pixel   : natural range 0 to 2;
    variable pixel_step,
      pm_step : natural range 0 to 7;
    variable frame_downs, readout_rows,
      row_pixels : natural range 0 to 1280;
  begin
    if (sysc.reset = '1') then
      state <= (others => '0');
      stack        := (others => FRAME);
      ft           := '0';
      row_down     := '0';
      idx          := 0;
      down_pixel   := 0;
      pixel_step   := 0;
      pm_step      := 0;
      frame_downs  := 0;
      readout_rows := 0;
      row_pixels   := 0;
    elsif (rising_edge(iSCLK)) then
      case stack(idx) is
        when FRAME =>
          --printf("FRAME ");
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
          --printf("READOUT ");
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
          --printf("ROW ");
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
          --printf("DOWN ");
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
          --printf("PIXEL_MAYBE ");
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
          --printf("PIXEL ");
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
