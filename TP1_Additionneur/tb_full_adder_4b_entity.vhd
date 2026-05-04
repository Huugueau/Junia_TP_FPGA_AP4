library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DECLARATION D'UNE ENTITE
entity tb_full_adder_4b is
end tb_full_adder_4b;

architecture tb of tb_full_adder_4b is
    -- Déclaration des signaux de test
    signal A, B: std_logic_vector(3 downto 0);
    signal Cin: std_logic;
    signal S: std_logic_vector(3 downto 0);
    signal Cout: std_logic;

begin
    -- Instanciation de l'entité testée, récupérée dans la librairie work
    -- On appelle cette instance UUT (Unit Under Test)
	UUT : entity work.full_adder_4b port map (
        A => A,
        B => B,
        Cin => Cin,
        S => S,
        Cout => Cout
	);

	-- Description des stimuli
	-- A placer dans des *process*, car ce sont des instructions séquentielles
	-- (Plusieurs process concurrents peuvent être décrits)
	stimuli1 : process
		begin

        A <= "0000"; B <= "0000"; Cin <= '0';
        assert (S = "0000" and Cout = '0') report "Test 0 + 0 + 0 failed" severity error;
        wait for 10ns;


        A <= "0001"; B <= "0001"; Cin <= '0';
        assert (S = "0010" and Cout = '0') report "Test 1 + 1 + 0 failed" severity error;
        wait for 10ns;

        A <= "0010"; B <= "0010"; Cin <= '0';
        assert (S = "0010" and Cout = '0') report "Test 2 + 2 + 0 failed" severity error;
        wait for 10ns;


        A <= "0011"; B <= "0011"; Cin <= '0';
        assert (S = "0110" and Cout = '0') report "Test 3 + 3 + 0 failed" severity error;
        wait for 10ns;


        A <= "0100"; B <= "0100"; Cin <= '0';
        assert (S = "1000" and Cout = '0') report "Test 4 + 4 + 0 failed" severity error;
        wait for 10ns;


        A <= "0101"; B <= "0101"; Cin <= '0';
        assert (S = "1010" and Cout = '0') report "Test 5 + 5 + 0 failed" severity error;
        wait for 10ns;


        A <= "0110"; B <= "0110"; Cin <= '0';
        assert (S = "1100" and Cout = '0') report "Test 6 + 6 + 0 failed" severity error;
        wait for 10ns;


        A <= "0111"; B <= "0111"; Cin <= '0';
        assert (S = "1110" and Cout = '0') report "Test 7 + 7 + 0 failed" severity error;
        wait for 10ns;


        A <= "1000"; B <= "1000"; Cin <= '0';
        assert (S = "0000" and Cout = '1') report "Test 8 + 8 + 0 failed" severity error;
        wait for 10ns;


        A <= "1001"; B <= "1001"; Cin <= '0';
        assert (S = "0010" and Cout = '1') report "Test 9 + 9 + 0 failed" severity error;
        wait for 10ns;


        A <= "1010"; B <= "1010"; Cin <= '0';
        assert (S = "0100" and Cout = '1') report "Test 10 + 10 + 0 failed" severity error;
        wait for 10ns;


        A <= "1011"; B <= "1011"; Cin <= '0';
        assert (S = "0110" and Cout = '1') report "Test 11 + 11 + 0 failed" severity error;
        wait for 10ns;


        A <= "1100"; B <= "1100"; Cin <= '0';
        assert (S = "1000" and Cout = '1') report "Test 12 + 12 + 0 failed" severity error;
        wait for 10ns;


        A <= "1101"; B <= "1101"; Cin <= '0';
        assert (S = "1010" and Cout = '1') report "Test 13 + 13 + 0 failed" severity error;
        wait for 10ns;


        A <= "1110"; B <= "1110"; Cin <= '0';
        assert (S = "1100" and Cout = '1') report "Test 14 + 14 + 0 failed" severity error;
        wait for 10ns;


        A <= "1111"; B <= "1111"; Cin <= '0';
        assert (S = "1110" and Cout = '1') report "Test 15 + 15 + 0 failed" severity error;
        wait for 10ns;


        A <= "1111"; B <= "1111"; Cin <= '1';
        assert (S = "1111" and Cout = '1') report "Test 15 + 15 + 1 failed" severity error;
        wait for 10ns;


        wait;

	end process;
end tb ;
