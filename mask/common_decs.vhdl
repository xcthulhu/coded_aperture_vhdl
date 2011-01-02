package common_decs is
  constant image_size : integer := 499;
  -- FIXME: We should just use std_logic_vectors as counters
  type image_array is array (0 to image_size) of integer range -2047 to +2047;
  subtype event_type is integer;
end package common_decs;
