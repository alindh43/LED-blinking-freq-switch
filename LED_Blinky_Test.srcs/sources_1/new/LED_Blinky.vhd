----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2026 10:45:02 AM
-- Design Name: 
-- Module Name: LED_Blinky - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: VHDL code fo switching the frequency (100Hz, 50Hz, 10Hz, 1Hz)  of led0 using physical switches (0, 1, 2, and 3)
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LED_Blinky is
    generic(
        CLOCK_FREQ_HZ : natural := 125000000
        ); 
    port (
        clock      : in std_logic;
        rst_n      : in std_logic;
        switches   : in std_logic_vector(3 downto 0);
        led0       : out std_logic
        );
end LED_Blinky;


architecture rtl of LED_Blinky is

    -- Constants to create the frequencies
    constant const_100HZ : natural := CLOCK_FREQ_HZ / (2*100);  -- 100HZ: 125e6 / (2*100)
    constant const_50HZ  : natural := CLOCK_FREQ_HZ / (2*50);   -- 50HZ:  125e6 / (2*50)
    constant const_10HZ  : natural := CLOCK_FREQ_HZ / (2*10);   -- 10HZ:  125e6 / (2*10)
    constant const_1HZ   : natural := CLOCK_FREQ_HZ / (2*1);    -- 1HZ:   125e6 / (2*1)
    
    -- Counter Signal
    signal count : natural range 0 to const_1HZ-1;
    
  
    -- One bit select wire
    signal led_out : std_logic := '0';
    
    -- Frequency Chooser    
    signal div_max   : natural range 0 to const_1HZ;
    
    -- Ensuring clean switching of div_max
    signal div_max_r : natural range 0 to const_1HZ;
    
    
    -- Clock Synchronized Switches
    signal switches_ff1, switches_ff2 : std_logic_vector(3 downto 0);
    
  
---------------------------------------------------------------------------------------------------------------------------------------------------
    begin
        
        -- Synchronising Switches to Clock with 2FF
        p_switch_sync : process (clock)
        begin
            if rising_edge(clock) then
                switches_ff1 <= switches;
                switches_ff2 <= switches_ff1;
            end if;
        end process p_switch_sync;
    
    
        -- Frquency Selector Based on Switch Position
        p_freq_selector : process (clock)
        begin
            if rising_edge(clock) then
                case switches_ff2 is
                    when "0001" => div_max <= const_1HZ;
                    when "0010" => div_max <= const_10HZ;
                    when "0100" => div_max <= const_50HZ;
                    when "1000" => div_max <= const_100HZ;
                    when others => div_max <= const_1HZ;
                end case;
            end if;
        end process p_freq_selector;  
                                      
                 
        -- Frequnecy Switching on the LED                   
        p_led_freq_switching : process(clock)           
        begin
            if rising_edge(clock) then
                if rst_n = '0' then
                    count <= 0;
                    led_out <= '0';
                    div_max_r <= div_max;
                elsif div_max /= div_max_r then
                    --If div_max changes (i.e div_max /= div_max_r) we want to reset count so that there is no missmatch there    
                    count <= 0;
                    div_max_r <= div_max;
                elsif count = div_max-1 then
                    count <= 0;
                    led_out <= not led_out;
                else
                    count <= count + 1;
                end if;
            end if;
        end process p_led_freq_switching;        
        
        led0 <= led_out;
---------------------------------------------------------------------------------------------------------------------------------------------------
              

end rtl;
