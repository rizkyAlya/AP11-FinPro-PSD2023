library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ConverterPassword is
    port (
        clk : in std_logic;
        reset : in std_logic;
        inputPass : in integer range 0 to 999999;
        outputPass : out std_logic_vector(31 downto 0)
    );
end ConverterPassword;

architecture Behavioral of ConverterPassword is
    signal passwordIn : integer range 0 to 999999;
    signal passwordOut : std_logic_vector(31 downto 0);

    begin
        process(clk, reset)
        begin
            if reset = '1' then
                passwordIn <= 0;
                passwordOut <= (others => '0');
            elsif rising_edge(clk) then
                passwordIn <= inputPass;
                passwordOut <= std_logic_vector(to_unsigned(passwordIn, passwordOut'length));
            end if;
    end process;

    outputPass <= passwordOut;
end Behavioral;