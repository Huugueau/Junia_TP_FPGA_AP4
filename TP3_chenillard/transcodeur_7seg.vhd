library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- table correspondance hex to 7seg:

-- 0 -> 1000000
-- 1 -> 1111001
-- 2 -> 0100100
-- 3 -> 0110000
-- 4 -> 0011001
-- 5 -> 0010010
-- 6 -> 0000010
-- 7 -> 1111000
-- 8 -> 0000000
-- 9 -> 0010000
-- A -> 0100000
-- B -> 0000011
-- C -> 1000110
-- D -> 0100001
-- E -> 0000110
-- F -> 0001110

-- - -> 0111111 -> 0000
-- O -> 1000000 -> 0001
-- P -> 0001100 -> 0010
-- E ->         -> 0011
-- n -> 0101011 -> 0100
-- r -> 0101111 -> 0101




entity transcodeur_7seg is 
    port(
        BIN: in std_logic_vector(3 downto 0);
        SEG: out std_logic_vector(6 downto 0)
    );
end transcodeur_7seg;
architecture behavioral of transcodeur_7seg is 
    begin
        with BIN select
            SEG<="0111111" when "0000";
                "1000000" when "0001";
                "0001100" when "0010";
                "0000110" when "0011";
                "0101011" when "0100";
                "0101111" when "0101";
                "1111111" when others;

end behavioral;