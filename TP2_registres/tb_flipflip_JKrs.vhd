library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_flipflop_JKrs is
end entity tb_flipflop_JKrs;

architecture sim of tb_flipflop_JKrs is

    signal J    : std_logic := '0';
    signal K    : std_logic := '0';
    signal CLK  : std_logic := '0';
    signal RSTn : std_logic := '1';
    signal SETn : std_logic := '1';
    signal Q    : std_logic;
    signal QN   : std_logic;

    constant CLK_PERIOD : time := 20 ns;

    -- Drapeau pour stopper l'horloge en fin de simulation
    signal sim_done : boolean := false;

    procedure check_q (
        signal   Q_s, QN_s : in std_logic;
        constant Q_exp     : in std_logic;
        constant msg       : in string
    ) is
    begin
        assert Q_s = Q_exp
            report "FAIL [" & msg & "] : Q attendu = " & std_logic'image(Q_exp)
                                & ", Q observe = " & std_logic'image(Q_s)
            severity failure;
        assert QN_s = not Q_exp
            report "FAIL [" & msg & "] : QN devrait etre l'inverse de Q"
            severity failure;
    end procedure;

begin

    DUT : entity work.flipflop_JKrs
        port map (
            J    => J,
            K    => K,
            CLK  => CLK,
            RSTn => RSTn,
            SETn => SETn,
            Q    => Q,
            QN   => QN
        );

    -- Génération de l'horloge (s'arrête quand sim_done passe à true)
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

    stim : process
    begin
        ------------------------------------------------------------------
        -- 1) Reset asynchrone
        ------------------------------------------------------------------
        RSTn <= '0';
        SETn <= '1';
        J    <= '0';
        K    <= '0';
        wait for 30 ns;
        check_q(Q, QN, '0', "reset asynchrone -> Q = 0");

        RSTn <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;  -- petit delta pour observer la sortie

        ------------------------------------------------------------------
        -- 2) Hold (J=K=0) : Q doit rester à 0
        ------------------------------------------------------------------
        J <= '0'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '0', "hold apres reset -> Q = 0");

        ------------------------------------------------------------------
        -- 3) Set synchrone (J=1, K=0) : Q passe à 1
        ------------------------------------------------------------------
        J <= '1'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '1', "J=1 K=0 -> Q = 1");

        ------------------------------------------------------------------
        -- 4) Hold (J=K=0) : Q doit rester à 1
        ------------------------------------------------------------------
        J <= '0'; K <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '1', "hold a 1 -> Q = 1");

        ------------------------------------------------------------------
        -- 5) Reset synchrone (J=0, K=1) : Q passe à 0
        ------------------------------------------------------------------
        J <= '0'; K <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '0', "J=0 K=1 -> Q = 0");

        ------------------------------------------------------------------
        -- 6) Toggle (J=K=1) : Q bascule à chaque front
        --    On part de Q=0 -> 1 -> 0 -> 1
        ------------------------------------------------------------------
        J <= '1'; K <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '1', "toggle 1 -> Q = 1");

        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '0', "toggle 2 -> Q = 0");

        wait until rising_edge(CLK);
        wait for 1 ns;
        check_q(Q, QN, '1', "toggle 3 -> Q = 1");

        ------------------------------------------------------------------
        -- 7) Set asynchrone : on impose Q=1 hors front d'horloge
        --    On se met d'abord dans un état stable J=0 K=1 pour que la
        --    bascule "voudrait" passer à 0 au prochain front, puis on
        --    déclenche SETn pendant que CLK est bas.
        ------------------------------------------------------------------
        J <= '0'; K <= '1';
        wait until falling_edge(CLK);   -- on se place après un front, CLK = 0
        wait for 2 ns;
        SETn <= '0';
        wait for 5 ns;                  -- pulse asynchrone, sans front d'horloge
        check_q(Q, QN, '1', "set asynchrone -> Q = 1");
        SETn <= '1';
        wait for 2 ns;

        ------------------------------------------------------------------
        -- 8) Reset asynchrone : on impose Q=0 hors front d'horloge
        ------------------------------------------------------------------
        J <= '1'; K <= '0';             -- la bascule "voudrait" Q=1
        wait until falling_edge(CLK);
        wait for 2 ns;
        RSTn <= '0';
        wait for 5 ns;
        check_q(Q, QN, '0', "reset asynchrone -> Q = 0");
        RSTn <= '1';
        wait for 2 ns;

        ------------------------------------------------------------------
        -- 9) Priorité du reset sur le set : les deux actifs -> Q = 0
        ------------------------------------------------------------------
        J <= '1'; K <= '1';
        wait until falling_edge(CLK);
        wait for 2 ns;
        RSTn <= '0';
        SETn <= '0';
        wait for 10 ns;
        check_q(Q, QN, '0', "RSTn et SETn actifs -> Q = 0 (reset prioritaire)");
        RSTn <= '1';
        SETn <= '1';

        ------------------------------------------------------------------
        -- Fin
        ------------------------------------------------------------------
        report "==> Tous les tests JKrs ont passe avec succes." severity note;
        sim_done <= true;
        wait;
    end process stim;

end architecture sim;
