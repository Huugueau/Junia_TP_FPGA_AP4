library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DESCRIPTION DES ENTREES/SORTIES DE L'ENTITY
entity full_adder is
	port (
        A: in std_logic;
        B: in std_logic;
        Cin: in std_logic;
        S: out std_logic;
        Cout: out std_logic
	);
end entity full_adder;

-- DESCRIPTION COMPORTEMENTALE DE L'ENTITY
architecture behavioral of full_adder is
    signal SA: std_logic;
    signal C1Cout: std_logic;
    signal C2Cout: std_logic;
begin
    -- Instanciation du premier demi-additionneur
    entity work.half_adder
        port map (
            A => A,
            B => B,
            S => SA,
            C => C1Cout
        );
    -- Instanciation du second demi-additionneur
    entity work.half_adder
        port map (
            A => SA,
            B => Cin,
            S => S,
            C => C2Cout
        );
    -- Calcul retenue de sortie
    Cout <= C1Cout or C2Cout;
end behavioral;
