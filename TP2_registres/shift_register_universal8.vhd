library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- REGISTRE UNIVERSEL 8 BITS
--
-- 6 modes opératoires sélectionnés par SEL (3 bits) :
--   X00 : Hold              (mémorisation)
--   X11 : Parallel load     (chargement parallèle Pi)
--   001 : Shift right       (décalage à droite, entrée série SSR)
--   010 : Shift left        (décalage à gauche, entrée série SSL)
--   101 : Rotate right      (rotation à droite)
--   110 : Rotate left       (rotation à gauche)
--
-- Convention bits : Qo(7) = MSB (à gauche), Qo(0) = LSB (à droite)
--
--   "shift right"  : MSB <- SSR, les bits glissent vers le LSB
--                    Qo+ = SSR & Qo(7..1)        ; le bit perdu (Qo(0)) sort sur SOR
--   "shift left"   : LSB <- SSL, les bits glissent vers le MSB
--                    Qo+ = Qo(6..0) & SSL        ; le bit perdu (Qo(7)) sort sur SOL
--   "rotate right" : Qo+ = Qo(0) & Qo(7..1)
--   "rotate left"  : Qo+ = Qo(6..0) & Qo(7)
--
-- Sorties série :
--   SOR = Qo(0)  (bit qui "sort" à droite lors d'un shift right)
--   SOL = Qo(7)  (bit qui "sort" à gauche lors d'un shift left)

entity shift_register_universal8 is
    port (
        SSR  : in  std_logic;
        SSL  : in  std_logic;
        Pi   : in  std_logic_vector(7 downto 0);
        SEL  : in  std_logic_vector(2 downto 0);
        CLK  : in  std_logic;
        SETn : in  std_logic;  -- Preset asynchrone, actif bas (-> tous les bits à 1)
        RSTn : in  std_logic;  -- Reset  asynchrone, actif bas (-> tous les bits à 0)
        SOR  : out std_logic;
        SOL  : out std_logic;
        Qo   : out std_logic_vector(7 downto 0)
    );
end entity shift_register_universal8;


architecture behavioral of shift_register_universal8 is
    signal Qo_int : std_logic_vector(7 downto 0) := (others => '0');
begin

    process (CLK, RSTn, SETn)
    begin
        -- Reset prioritaire sur Set (cohérent avec la bascule JKrs)
        if (RSTn = '0') then
            Qo_int <= (others => '0');
        elsif (SETn = '0') then
            Qo_int <= (others => '1');
        elsif rising_edge(CLK) then
            -- Décodage de SEL :
            --   bit 2 = 1  => rotate (au lieu de shift)
            --   bits 1..0 = 00 => hold
            --   bits 1..0 = 11 => parallel load
            --   bits 1..0 = 01 => right
            --   bits 1..0 = 10 => left
            --
            -- On traite les 8 cas explicitement (pas de boucle, pas de
            -- with/select pour rester dans le process).

            if    (SEL = "000") then
                Qo_int <= Qo_int;                         -- Hold
            elsif (SEL = "100") then
                Qo_int <= Qo_int;                         -- Hold (X00)
            elsif (SEL = "011") then
                Qo_int <= Pi;                             -- Parallel load
            elsif (SEL = "111") then
                Qo_int <= Pi;                             -- Parallel load (X11)
            elsif (SEL = "001") then
                -- Shift right : SSR entre par le MSB
                Qo_int <= SSR & Qo_int(7 downto 1);
            elsif (SEL = "010") then
                -- Shift left : SSL entre par le LSB
                Qo_int <= Qo_int(6 downto 0) & SSL;
            elsif (SEL = "101") then
                -- Rotate right : Qo(0) revient sur le MSB
                Qo_int <= Qo_int(0) & Qo_int(7 downto 1);
            elsif (SEL = "110") then
                -- Rotate left : Qo(7) revient sur le LSB
                Qo_int <= Qo_int(6 downto 0) & Qo_int(7);
            else
                Qo_int <= Qo_int;
            end if;
        end if;
    end process;

    -- Sorties
    Qo  <= Qo_int;
    SOR <= Qo_int(0);
    SOL <= Qo_int(7);

end architecture behavioral;
