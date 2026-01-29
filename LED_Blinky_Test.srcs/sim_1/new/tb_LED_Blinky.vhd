library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LED_Blinky is
end entity;

architecture sim of tb_LED_Blinky is
    
    signal clock    : std_logic := '0';
    signal rst_n    : std_logic := '1';
    signal switches : std_logic_vector(3 downto 0);
    signal led0     : std_logic;

    -- Reduced clock speed (1 MHz) to reduce simulation time 
    constant CLK_PERIOD : time := 1us; 
    
    
begin
    
    ------------------------------------------------------------------
    -- DUT instantiation
    ------------------------------------------------------------------
    uut: entity work.LED_Blinky
        generic map (
            CLOCK_FREQ_HZ => 1_000_000
        )
        port map (
            clock    => clock,
            rst_n    => rst_n,
            switches => switches,
            led0     => led0
        );
        
    
    ------------------------------------------------------------------
    -- Clock generation
    ------------------------------------------------------------------
    clk_gen : process
    begin
        while true loop
            clock <= '0';
            wait for CLK_PERIOD / 2;
            clock <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    
    ------------------------------------------------------------------
    -- Stimulus process
    ------------------------------------------------------------------
    stim_proc : process
    begin 
        --Apply reset
        wait for 100ns;
        rst_n <= '0';
        wait for 100ns;
        switches <= "0000";
        wait for 100 ns;
        
        rst_n <= '1';
        wait for 100 ns;
        
        -- 1 Hz
        switches <= "0001";
        wait for 3 sec;
        
        -- 10 Hz
        switches <= "0010";
        wait for 1 sec;
        
        -- 50 Hz
        switches <= "0100";
        wait for 500 ms;
        
        -- 100 Hz
        switches <= "1000";
        wait for 300 ms;
        
        -- Invalid / multiple switches. Should give 1 Hz
        switches <= "1111";
        wait for 1 sec;
        
        --Back to 1 Hz
        switches <= "0001";
        wait for 2 sec;
        
        --End simulation
        assert false
            report "Simulation finished"
            severity failure;
  
    end process;

end architecture;