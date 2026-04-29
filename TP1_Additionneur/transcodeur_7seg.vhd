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


entity transcodeur_7seg is 
    port(
        BIN: in std_logic(3 downto 0);
        SEG: out std_logic(6 downto 0)
    );
end transcodeur_7seg;
architecture behavioral of transcodeur_7seg is 
    begin
        with BIN select
            SEG<="1000000" when "0000",
                "1111001" when "0001",
                "0100100" when "0010",
                "0110000" when "0011",
                "0011001" when "0100",
                "0010010" when "0101",
                "0000010" when "0110",
                "1111000" when "0111",
                "0000000" when "1000",
                "0010000" when "1001",
                "0100000" when "1010",
                "0000011" when "1011",
                "1000110" when "1100",
                "0100001" when "1101",
                "0000110" when "1110",
                "0001110" when "1111";

end behavioral;