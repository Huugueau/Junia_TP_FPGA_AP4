library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- FLIP-FLOP JK avec Set et Reset Asynchrones (actifs à l'état bas)
--
-- Table de caractéristiques :
-- ----------------------------------------
-- | J | K | CLK | RSTn | SETn | Q+ | QN+ |
-- | X | X |  X  |  0   |  1   | 0  |  1  | (reset asynchrone, prioritaire)
-- | X | X |  X  |  1   |  0   | 1  |  0  | (set asynchrone)
-- | 0 | 0 |  ↑  |  1   |  1   | Q  | QN  | (mémoire)
-- | 0 | 1 |  ↑  |  1   |  1   | 0  |  1  | (mise à zéro)
-- | 1 | 0 |  ↑  |  1   |  1   | 1  |  0  | (mise à un)
-- | 1 | 1 |  ↑  |  1   |  1   | QN |  Q  | (complément)
-- ----------------------------------------
--
-- NB : RSTn est prioritaire sur SETn (choix arbitraire mais classique)

entity flipflop_JKrs is
    port (
        J    : in  std_logic;
        K    : in  std_logic;
        CLK  : in  std_logic;
        RSTn : in  std_logic;  -- Reset asynchrone, actif bas
        SETn : in  std_logic;  -- Set   asynchrone, actif bas
        Q    : out std_logic;
        QN   : out std_logic
    );
end entity flipflop_JKrs;


architecture behavioral of flipflop_JKrs is
    signal Q_int : std_logic := '0';
begin

    process (CLK, RSTn, SETn)
    begin
        if (RSTn = '0') then
            Q_int <= '0';                    -- reset asynchrone (prioritaire)
        elsif (SETn = '0') then
            Q_int <= '1';                    -- set asynchrone
        elsif rising_edge(CLK) then
            if (J = '0' and K = '0') then
                Q_int <= Q_int;              -- mémoire
            elsif (J = '0' and K = '1') then
                Q_int <= '0';                -- mise à zéro
            elsif (J = '1' and K = '0') then
                Q_int <= '1';                -- mise à un
            else  -- J = '1' and K = '1'
                Q_int <= not Q_int;          -- complément
            end if;
        end if;
    end process;

    Q  <= Q_int;
    QN <= not Q_int;

end architecture behavioral;
