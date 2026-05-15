library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- FLIP-FLOP JK Synchrone
--
-- Table de caractéristiques du flip-flop JK :
-- -------------------------------
-- | J | K | CLK | Q+  | QN+      |
-- | 0 | 0 |  ↑  | Q   | QN       | (mémoire)
-- | 0 | 1 |  ↑  | 0   | 1        | (mise à zéro)
-- | 1 | 0 |  ↑  | 1   | 0        | (mise à un)
-- | 1 | 1 |  ↑  | QN  | Q        | (complément)
-- -------------------------------
--
-- Table de transition du flip-flop JK :
-- ------------------------
-- | Q | Q+ | J | K | CLK |
-- | 0 | 0  | 0 | X | ↑   |
-- | 0 | 1  | 1 | X | ↑   |
-- | 1 | 0  | X | 1 | ↑   |
-- | 1 | 1  | X | 0 | ↑   |
-- ------------------------

entity flipflop_JK is
    port (
        J   : in  std_logic;
        K   : in  std_logic;
        CLK : in  std_logic;
        Q   : out std_logic;
        QN  : out std_logic
    );
end entity flipflop_JK;


architecture behavioral of flipflop_JK is
    -- Signal interne car on ne peut pas lire un port de mode 'out'
    -- (et il faut bien lire Q pour le cas mémoire et le cas toggle)
    signal Q_int : std_logic := '0';
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if (J = '0' and K = '0') then
                Q_int <= Q_int;             -- mémoire
            elsif (J = '0' and K = '1') then
                Q_int <= '0';               -- mise à zéro
            elsif (J = '1' and K = '0') then
                Q_int <= '1';               -- mise à un
            else  -- J = '1' and K = '1'
                Q_int <= not Q_int;         -- complément
            end if;
        end if;
    end process;

    -- Sorties (assignations concurrentes, hors process)
    Q  <= Q_int;
    QN <= not Q_int;

end architecture behavioral;
