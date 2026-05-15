library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
port (
HEX3 : out std_logic_vector(6 downto 0);
HEX2 : out std_logic_vector(6 downto 0);
HEX1 : out std_logic_vector(6 downto 0);
HEX0 : out std_logic_vector(6 downto 0);
SW : in std_logic_vector(9 downto 0)
);
end top_level;

architecture behavioral of top_level is 
    signal S, Cout : std_logic_vector(3 downto 0);
    begin 
        -- affichage A
        instance_transcodeur_7seg_3: entity work.transcodeur_7seg port map(
            BIN => "0001",
            SEG => HEX3
            );
        -- affichage B
        istance_transcodeur_7seg_2: entity work.transcodeur_7seg port map(
            BIN => "0010",
            SEG => HEX2
        );
        -- affichage C
        instance_transcodeur_7seg_0: entity work.transcodeur_7seg port map(
            BIN => "0011",
            SEG => HEX0
        );

        -- affichage D
        instance_transcodeur_7seg_1: entity work.transcodeur_7seg port map(
            BIN => "0100",
            SEG => HEX1
        );


end behavioral;

        