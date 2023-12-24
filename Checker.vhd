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
	    access_denied : out std_logic;
        done : out std_logic
    );
end Checker;

architecture Behavioral of Checker is

begin
    process(clk, reset)
    begin
        if reset = '1' then
            access_denied <= '0';
            access_granted <= '0';
        elsif rising_edge(clk) then
            if input_password = correct_password then
                access_granted <= '1';
                done <= '1';
                report "Access Allowed!";
            else
                access_granted <= '0';
                access_denied <= '1';
                done <= '1';
                report "Access Denied!";
            end if;
        end if;
    end process;
end Behavioral;
