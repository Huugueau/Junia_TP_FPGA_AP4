library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chenillard is
    port (
        CLK: in std_logic;
        RSTn: in std_logic;
        CHEN: out std_logic_vector(9 downto 0)
    );
end entity chenillard;

architecture behavioral of chenillard is
    signal state : integer range 0 to 9 := 0;
begin
    process (CLK, RSTn)
    begin
        if (RSTn = '0') then
            state <= 0;  -- reset asynchrone
        elsif rising_edge(CLK) then
            if (state = 9) then
                state <= 0;
            else
                state <= state + 1;
            end if;
        end if;
    end process;

    with state select
        CHEN <= "0000001111" when 0,
                "0000011110" when 1,
                "0000111100" when 2,
                "0001111000" when 3,
                "0011110000" when 4,
                "0111100000" when 5,
                "1111000000" when 6,
                "1110000001" when 7,
                "1100000011" when 8,
                "1000000111" when 9;

end architecture behavioral;
