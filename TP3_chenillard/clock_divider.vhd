library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity clock_divider is
    port(
        CLKin: in std_logic;
        RST: in std_logic;
        N: in std_logic_vector(4 downto 0);
        CLKout: out std_logic
    );
end clock_divider;

-- calcul de l'horloge de sortie à partir de l'horloge d'entrée et du diviseur N
architecture behavioral of clock_divider is
    signal count : std_logic_vector(23 downto 0) := (others => '0');
    begin
        process(CLKin, RST)
        begin
            if RST = '0' then
                count <= (others => '0');
            elsif rising_edge(CLkin) then
                count <= count + 1;
            end if;
        end process;
    with N select
        CLKout <=
                    count(0)  when "00001", -- diviseur 2
                    count(1)  when "00010", -- diviseur 4
                    count(2)  when "00011", -- diviseur 8
                    count(3)  when "00100", -- diviseur 16
                    count(4)  when "00101", -- diviseur 32
                    count(5)  when "00110", -- diviseur 64
                    count(6)  when "00111", -- diviseur 128
                    count(7)  when "01000", -- diviseur 256
                    count(8)  when "01001", -- diviseur 512
                    count(9)  when "01010", -- diviseur 1024
                    count(10) when "01011", -- diviseur 2048
                    count(11) when "01100", -- diviseur 4096
                    count(12) when "01101", -- diviseur 8192
                    count(13) when "01110", -- diviseur 16384
                    count(14) when "01111", -- diviseur 32768
                    count(15) when "10000", -- diviseur 65536
                    count(16) when "10001", -- diviseur 131072
                    count(17) when "10010", -- diviseur 262144
                    count(18) when "10011", -- diviseur 524288
                    count(19) when "10100", -- diviseur 1048576
                    count(20) when "10101", -- diviseur 2097152
                    count(21) when "10110", -- diviseur 4194304
                    count(22) when "10111", -- diviseur 8388608
                    count(23) when "11000", -- diviseur 16777216
                    '0' when others;

end architecture;
