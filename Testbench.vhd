library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench is
end Testbench;

architecture Behavioral of Testbench is

    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic;

    -- Ini buat ConverterPassword
    signal inputPass_tb : integer range 0 to 999999;
    signal outputPass_tb : std_logic_vector(31 downto 0);

    -- Ini buat Checker
    signal input_password_tb : std_logic_vector(31 downto 0);
    signal correct_password_tb : std_logic_vector(31 downto 0);
    signal access_granted_tb : std_logic;
    signal access_denied_tb : std_logic;
    signal doneCheck : std_logic;

    -- Ini buat MD5
    signal data_in_tb : STD_LOGIC_VECTOR (31 downto 0);
    signal data_out_tb : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal done_tb : STD_LOGIC := '0';
    signal err_tb : STD_LOGIC := '0';
    signal start_tb : STD_LOGIC;

    -- Ini buat MD5_2
    signal data_in_tb2 : STD_LOGIC_VECTOR (31 downto 0);
    signal data_out_tb2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal done_tb2 : STD_LOGIC := '0';
    signal err_tb2 : STD_LOGIC := '0';
    signal start_tb2 : STD_LOGIC;

    -- Ini clock
    constant CLOCK_PERIOD : time := 10 ns;

    signal savePassword1 : std_logic_vector(31 downto 0);
    signal savePassword2 : std_logic_vector(31 downto 0);

    component ConverterPassword is
        port (
            clk : in std_logic;
            reset : in std_logic;
            inputPass : in integer range 0 to 999999;
            outputPass : out std_logic_vector(31 downto 0)
        );
    end component;

    component Checker is
        Port (
            reset : in std_logic;
            clk : in std_logic;
            input_password : in std_logic_vector(31 downto 0);
            correct_password : in std_logic_vector(31 downto 0);
            access_granted : out std_logic;
            access_denied : out std_logic;
            done : out std_logic
        );
    end component;

    component MD5 is
        Port (
            data_in : in  STD_LOGIC_VECTOR (31 downto 0);
            data_out : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
            done : out STD_LOGIC := '0';
            err : out STD_LOGIC := '0';
            start : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            reset : in  STD_LOGIC);
    end component;

    component MD5_2 is
        Port (
            data_in : in  STD_LOGIC_VECTOR (31 downto 0);
            data_out : out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
            done : out STD_LOGIC := '0';
            err : out STD_LOGIC := '0';
            start : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            reset : in  STD_LOGIC);
    end component;

    begin
        
        -- Portmap ConverterPassword
        UUT1 : ConverterPassword 
            port map (
                clk         => clk_tb,
                reset       => reset_tb,
                inputPass   => inputPass_tb,
                outputPass  => outputPass_tb
            );

        -- Portmap Checker
        UUT2 : Checker 
            port map (
                reset               => reset_tb,
                clk                 => clk_tb,
                input_password      => input_password_tb,
                correct_password    => correct_password_tb,
                access_granted      => access_granted_tb,
                access_denied       => access_denied_tb,
                done                => doneCheck
            );

        -- Portmap MD5
        UUT3 : MD5 
            port map (
                data_in     => data_in_tb,
                data_out    => data_out_tb,
                done        => done_tb,
                err         => err_tb,
                start       => start_tb,
                clk         => clk_tb,
                reset       => reset_tb
            );
        -- Portmap MD5_2
        UUT4 : MD5_2
            port map (
                data_in     => data_in_tb2,
                data_out    => data_out_tb2,
                done        => done_tb2,
                err         => err_tb2,
                start       => start_tb2,
                clk         => clk_tb,
                reset       => reset_tb
            );

        -- Testbench
        Clock : process
        begin
            while now < 500 ns loop  -- Run for 500 ns
                clk_tb <= not clk_tb;
                wait for CLOCK_PERIOD / 2;
            end loop;
            wait;
        end process;

        Alur_Program : process
        begin

            wait for 20 ns;

            reset_tb <= '1';
            start_tb <= '0';
            wait for CLOCK_PERIOD;

            reset_tb <= '0';
            inputPass_tb <= 123456;
            wait for CLOCK_PERIOD;

            start_tb <= '1';
            data_in_tb <= outputPass_tb;
            wait until done_tb = '1';

            savePassword1 <= data_out_tb;
            wait for CLOCK_PERIOD;

            reset_tb <= '1';
            start_tb <= '0';
            wait for CLOCK_PERIOD;

            reset_tb <= '0';
            -- inputPass_tb <= 123400;
            inputPass_tb <= 123456;
            wait for CLOCK_PERIOD;
            
            start_tb2 <= '1';
            data_in_tb2 <= outputPass_tb;
            wait until done_tb2 = '1';

            savePassword2 <= data_out_tb2;
            wait for CLOCK_PERIOD;

            reset_tb <= '1';
            wait for CLOCK_PERIOD;

            reset_tb <= '0';
            input_password_tb <= savePassword2;
            correct_password_tb <= savePassword1;
            wait until doneCheck = '1';

        end process Alur_Program;

end Behavioral;
