library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shift_register_universal8 is
end entity tb_shift_register_universal8;

architecture sim of tb_shift_register_universal8 is

    signal SSR  : std_logic := '0';
    signal SSL  : std_logic := '0';
    signal Pi   : std_logic_vector(7 downto 0) := (others => '0');
    signal SEL  : std_logic_vector(2 downto 0) := "000";
    signal CLK  : std_logic := '0';
    signal SETn : std_logic := '1';
    signal RSTn : std_logic := '1';
    signal SOR  : std_logic;
    signal SOL  : std_logic;
    signal Qo   : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 20 ns;

    signal sim_done : boolean := false;

    -- Conversion d'un std_logic_vector en chaîne hexadécimale lisible
    function to_hex(v : std_logic_vector(7 downto 0)) return string is
        variable hex_chars : string(1 to 16) := "0123456789ABCDEF";
        variable msb_nibble : integer;
        variable lsb_nibble : integer;
    begin
        msb_nibble := to_integer(unsigned(v(7 downto 4)));
        lsb_nibble := to_integer(unsigned(v(3 downto 0)));
        return hex_chars(msb_nibble + 1) & hex_chars(lsb_nibble + 1);
    end function;

    -- Vérifie juste Qo (SOR et SOL sont vérifiés en continu plus bas)
    procedure check_value (
        signal   Qo_s     : in std_logic_vector(7 downto 0);
        constant expected : in std_logic_vector(7 downto 0);
        constant msg      : in string
    ) is
    begin
        assert Qo_s = expected
            report "FAIL [" & msg & "] : attendu = 0x" & to_hex(expected)
                                & ", observe = 0x" & to_hex(Qo_s)
            severity failure;
    end procedure;

begin

    DUT : entity work.shift_register_universal8
        port map (
            SSR  => SSR,
            SSL  => SSL,
            Pi   => Pi,
            SEL  => SEL,
            CLK  => CLK,
            SETn => SETn,
            RSTn => RSTn,
            SOR  => SOR,
            SOL  => SOL,
            Qo   => Qo
        );

    clk_gen : process
    begin
        while not sim_done loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_gen;

    -- Vérification continue : SOR = Qo(0), SOL = Qo(7)
    -- (process concurrent qui surveille en permanence)
    check_serial_outputs : process(Qo, SOR, SOL)
    begin
        assert SOR = Qo(0)
            report "FAIL : SOR doit etre egal a Qo(0)"
            severity failure;
        assert SOL = Qo(7)
            report "FAIL : SOL doit etre egal a Qo(7)"
            severity failure;
    end process;

    stim : process
    begin
        ------------------------------------------------------------------
        -- 1) Reset asynchrone : Qo doit etre 0x00
        ------------------------------------------------------------------
        RSTn <= '0';
        wait for 30 ns;
        check_value(Qo, x"00", "reset asynchrone");
        RSTn <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;

        ------------------------------------------------------------------
        -- 2) Set asynchrone : Qo doit etre 0xFF
        ------------------------------------------------------------------
        SETn <= '0';
        wait for 30 ns;
        check_value(Qo, x"FF", "set asynchrone");
        SETn <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;

        ------------------------------------------------------------------
        -- 3) Hold (SEL = 000) : Qo doit rester a 0xFF
        ------------------------------------------------------------------
        SEL <= "000";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"FF", "hold SEL=000");

        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"FF", "hold SEL=000 (2eme front)");

        -- Variante X00 (SEL = 100)
        SEL <= "100";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"FF", "hold SEL=100");

        ------------------------------------------------------------------
        -- 4) Chargement parallele Pi = 0xA5
        ------------------------------------------------------------------
        Pi  <= x"A5";
        SEL <= "011";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"A5", "parallel load SEL=011 -> 0xA5");

        -- Variante X11 (SEL = 111) : on charge 0x3C
        Pi  <= x"3C";
        SEL <= "111";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"3C", "parallel load SEL=111 -> 0x3C");

        ------------------------------------------------------------------
        -- 5) Shift right (SEL = 001) avec SSR = 1
        --    On part de 0xA5 = 10100101
        ------------------------------------------------------------------
        Pi  <= x"A5";
        SEL <= "011";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"A5", "reload 0xA5 avant shift right");

        SSR <= '1';
        SEL <= "001";
        --  10100101 -> 11010010 = 0xD2
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"D2", "shift right 1");

        --  11010010 -> 11101001 = 0xE9
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"E9", "shift right 2");

        --  11101001 -> 11110100 = 0xF4
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"F4", "shift right 3");

        ------------------------------------------------------------------
        -- 6) Shift left (SEL = 010) avec SSL = 0
        --    On part de 0xF4 = 11110100
        ------------------------------------------------------------------
        SSL <= '0';
        SEL <= "010";
        --  11110100 -> 11101000 = 0xE8
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"E8", "shift left 1");

        --  11101000 -> 11010000 = 0xD0
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"D0", "shift left 2");

        ------------------------------------------------------------------
        -- 7) Rotate right (SEL = 101) sur 0x81 = 10000001
        ------------------------------------------------------------------
        Pi  <= x"81";
        SEL <= "011";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"81", "reload 0x81 avant rotate right");

        SEL <= "101";
        --  10000001 -> 11000000 = 0xC0
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"C0", "rotate right 1");

        --  11000000 -> 01100000 = 0x60
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"60", "rotate right 2");

        --  01100000 -> 00110000 = 0x30
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"30", "rotate right 3");

        ------------------------------------------------------------------
        -- 8) Rotate left (SEL = 110) sur 0x81
        ------------------------------------------------------------------
        Pi  <= x"81";
        SEL <= "011";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"81", "reload 0x81 avant rotate left");

        SEL <= "110";
        --  10000001 -> 00000011 = 0x03
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"03", "rotate left 1");

        --  00000011 -> 00000110 = 0x06
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"06", "rotate left 2");

        --  00000110 -> 00001100 = 0x0C
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_value(Qo, x"0C", "rotate left 3");

        ------------------------------------------------------------------
        -- 9) Reset asynchrone prioritaire pendant un shift
        ------------------------------------------------------------------
        SEL <= "001";
        SSR <= '1';
        wait until falling_edge(CLK);
        wait for 2 ns;
        RSTn <= '0';
        wait for 5 ns;
        check_value(Qo, x"00", "reset asynchrone pendant shift");
        RSTn <= '1';
        wait for 2 ns;

        ------------------------------------------------------------------
        -- 10) Set asynchrone prioritaire
        ------------------------------------------------------------------
        wait until falling_edge(CLK);
        wait for 2 ns;
        SETn <= '0';
        wait for 5 ns;
        check_value(Qo, x"FF", "set asynchrone");
        SETn <= '1';

        ------------------------------------------------------------------
        -- 11) Priorite du reset sur le set
        ------------------------------------------------------------------
        wait until falling_edge(CLK);
        wait for 2 ns;
        RSTn <= '0';
        SETn <= '0';
        wait for 10 ns;
        check_value(Qo, x"00", "RSTn et SETn actifs : reset prioritaire");
        RSTn <= '1';
        SETn <= '1';

        ------------------------------------------------------------------
        -- Fin
        ------------------------------------------------------------------
        report "==> Tous les tests du registre universel 8b ont passe."
            severity note;
        sim_done <= true;
        wait;
    end process stim;

end architecture sim;
