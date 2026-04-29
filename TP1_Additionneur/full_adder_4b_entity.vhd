library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_4b is
    port (
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        Cin  : in  std_logic;
        S    : out std_logic_vector(3 downto 0);
        Cout : out std_logic
    );
end entity full_adder_4b;

architecture behavioral of full_adder_4b is
    signal C : std_logic_vector(4 downto 0);
begin
    C(0) <= Cin;

    gen_4b_add : for i in 0 to 3 generate
        adder_inst : entity work.full_adder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => C(i),
                S    => S(i),
                Cout => C(i+1)
            );
    end generate gen_4b_add;

    Cout <= C(4);
end behavioral;