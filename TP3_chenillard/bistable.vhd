library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Bistable Mahcine à état finis
--
-- A B C D => 4 états possibles
-- A : X = 0 => A
-- A : X = 1 => B
-- B : X = 1 => B
-- B : X = 0 => C
-- C : X = 0 => C
-- C : X = 1 => D
-- D : X = 1 => D
-- D : X = 0 => A

-- Fonction combinatoire current_state + entrée => future_state
-- A + 0 => A
-- A + 1 => B
-- B + 1 => B
-- B + 0 => C
-- C + 0 => C
-- C + 1 => D
-- D + 1 => D
-- D + 0 => A

-- Fonction combinatoire current_state => sortie
-- A => Y = 0
-- B => Y = 1
-- C => Y = 1
-- D => Y = 0



entity bistable is
	port(
        -- ENTREES
		CLK : in std_logic;
		RST : in std_logic;
        X: in std_logic;
		-- ...
		-- SORTIES
        Y: out std_logic
		-- ...

	);
end entity;

architecture behavioral of bistable is
	type state_type is (A, B, C, D);    -- Enumérer tous les états de la FSM ici
	signal fSTATE  : state_type; -- Etat futur, calculé à partir des entrées et de l'état présent
	signal cSTATE : state_type; -- Etat présent, reçoit future_state à chaque coup d'horloge

	begin

	-- Description du registre d'états
	-- Fonction SEQUENTIELLE
	process(CLK, RST)
	begin
		if RST = '0' then
			cSTATE <= A;
		elsif rising_edge(CLK) then
			cSTATE <= fSTATE;
		end if;

	end process;

	-- Description du calcul de l'état futur
	-- Fonction COMBINATOIRE
	process(X, cSTATE)
	begin
		case cSTATE is
			when A =>                                   -- when 1er état ...
				if    X = '0' then fSTATE <= A; --   if entrée = valeur1 then fSTATE <= état suivant1
				elsif X = '1' then fSTATE <= B; --   if entrée = valeur2 then fSTATE <= état suivant2
				else                 fSTATE <= A; --   etc.
				end if;
			when B =>                                   -- when 2ème état ...
				if    X = '1' then fSTATE <= B; --   if entrée = valeur1 then fSTATE <= état suivant1
				elsif X = '0' then fSTATE <= C; --   if entrée = valeur2 then fSTATE <= état suivant2
				else                 fSTATE <= B; --   etc.
				end if;
		 when C =>                                   -- when 3ème état ...
				if    X = '0' then fSTATE <= C; --   if entrée = valeur1 then fSTATE <= état suivant1
				elsif X = '1' then fSTATE <= D; --   if entrée = valeur2 then fSTATE <= état suivant2
				else                 fSTATE <= C; --   etc.
				end if;
		 when D =>                                   -- when 4ème état ...
				if    X = '1' then fSTATE <= D; --   if entrée = valeur1 then fSTATE <= état suivant1
				elsif X = '0' then fSTATE <= A; --   if entrée = valeur2 then fSTATE <= état suivant2
				else                 fSTATE <= D; --   etc.
				end if;
		end case;
	end process;

	-- Description du calcul des sorties
	-- Fonction COMBINATOIRE
	process(cSTATE)
	begin
		case cSTATE is
			when A => Y <= '0';
			when B => Y <= '1';
            when C => Y <= '1';
            when D => Y <= '0';
		end case;
	end process;
end behavioral;
