library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TOP LEVEL
--
-- Mapping :
--   SSR  <- SW(9)
--   SSL  <- SW(8)
--   SEL  <- SW(2..0)
--   Pi   <- "00000000" (chargement parallèle inutilisé)
--   RSTn <- KEY(3)
--   SETn <- KEY(2)
--   CLK  <- not(KEY(0))
--   Qo   -> LEDG(7..0)
--   SOR, SOL : non connectés
--
-- NB : sur la Cyclone V GX Starter Kit, les KEY sont actifs bas
-- (au repos = '1', appuyés = '0'), donc RSTn et SETn s'utilisent
-- directement sans inversion, ce qui correspond bien au comportement
-- attendu (active à l'état bas).

entity top_level is
    port (
        SW    : in  std_logic_vector(9 downto 0);
        KEY   : in  std_logic_vector(3 downto 0);
        LEDG  : out std_logic_vector(7 downto 0)
    );
end entity top_level;


architecture behavioral of top_level is

    signal clk_int : std_logic;

begin

    -- Horloge "manuelle" : un appui sur KEY(0) génère un front montant
    -- (KEY(0) au repos = '1' -> clk_int = '0' ; appui -> '0' -> clk_int = '1')
    clk_int <= not KEY(0);

    -- Instanciation du registre universel 8 bits
    U_REG : entity work.shift_register_universal8
        port map (
            SSR  => SW(9),
            SSL  => SW(8),
            Pi   => (others => '0'),
            SEL  => SW(2 downto 0),
            CLK  => clk_int,
            SETn => KEY(2),
            RSTn => KEY(3),
            SOR  => open,
            SOL  => open,
            Qo   => LEDG
        );

end architecture behavioral;
