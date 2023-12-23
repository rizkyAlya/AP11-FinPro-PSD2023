library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Checker is
    Port (
        reset : in std_logic;
        clk : in std_logic;
        input_password : in std_logic_vector(31 downto 0);
        correct_password : in std_logic_vector(31 downto 0);
        access_granted : out std_logic;
        access_denied : out std_logic
    );
end Checker;

architecture Behavioral of Checker is
    signal attempts_counter : integer := 0;
    signal password_matched : boolean := false;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            attempts_counter <= 0;
            access_denied <= '0';
        elsif rising_edge(clk) then
            if not password_matched then
                if input_password = correct_password then
                    password_matched <= true;
                    attempts_counter <= 0;
                    access_granted <= '1';
                    report "Access Allowed!";
                else
                    attempts_counter <= attempts_counter + 1;
                end if;
            end if;

            if attempts_counter = 3 then
                access_denied <= '1';
                report "Access Denied!";
                attempts_counter <= 0;
            else
                access_denied <= '0';
            end if;
        end if;
    end process;
end Behavioral;
