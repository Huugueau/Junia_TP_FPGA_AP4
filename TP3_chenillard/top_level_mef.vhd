library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Top level pour la machine à états fini bistable.vhd


entity top_level_mef is
    port (
                CLOCK_50_B6A: in std_logic;
                KEY: in std_logic_vector(3 downto 0);
                LEDG: out std_logic_vector(7 downto 0)
    );
end entity top_level_mef;

architecture structural of top_level_mef is

    component bistable
        port(
            CLK : in std_logic;
            RST : in std_logic;
            X   : in std_logic;
            Y   : out std_logic
        );
    end component;

    signal Y_out    : std_logic;

begin

    -- Instanciation du bistable
    bistable_inst : entity work.bistable
        port map (
            CLK => CLOCK_50_B6A,
            RST => KEY(0),  -- On peut réutiliser le même signal de reset
            X   => not KEY(1),  -- Inversion de X pour tester les transitions
            Y   => Y_out
        );

    -- Sortie vers les LEDs (on peut faire du multiplexage si on veut afficher plus d'infos)
    LEDG <= (others => Y_out);  -- Affiche la sortie Y sur toutes les LEDs pour la simplicité


end architecture;
