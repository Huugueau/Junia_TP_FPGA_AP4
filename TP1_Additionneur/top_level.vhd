library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
port (
HEX3 : out std_logic_vector(6 downto 0);
HEX2 : out std_logic_vector(6 downto 0);
HEX1 : out std_logic_vector(6 downto 0);
HEX0 : out std_logic_vector(6 downto 0);
SW : in std_logic_vector(9 downto 0)
);
end toplevel;

architecture behavioral of toplevel is 
    signal S, Cout : std_logic_vector(3 downto 0);
    begin 
        with SW select
            SEG<= HEX3 when "0000" or "0001" or "0010" or "0011",
                  HEX2 when "0100" or "0101" or "0110" or "0111";
        
        instance_full_adder_4b: entity work.full_adder_4b port map(
            A => SW(3 downto 0),
            A => SW(3 downto 0),
            Cin => SW(9),
            S => S,
            Cout => Cout(0)
        );

        