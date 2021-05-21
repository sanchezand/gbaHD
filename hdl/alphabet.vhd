-----------------------------------------------------------------------
-- Title: OSD alphabet
-- Author: sanchezand
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity alphabet is
    Port ( letter : in integer range 0 to 38;
           x : in integer range 0 to 4;
           y : in integer range 0 to 4;
           pixel : out STD_LOGIC);
end alphabet;

architecture rtl of alphabet is
signal letter_data : std_logic_vector(24 downto 0);
begin
    process(letter, x, y) is
    begin
        -- Letters from bottom right to top left of a 5x5 font.
        case(letter) is
            when 00 => letter_data <= ( others => '0' );
            when 01 => letter_data <= "1000110001111111000111111"; -- A
            when 02 => letter_data <= "0111110001011111000101111"; -- B
            when 03 => letter_data <= "0111010001000011000101110"; -- C
            when 04 => letter_data <= "0111110001100011000101111"; -- D
            when 05 => letter_data <= "1111100001011110000111111"; -- E
            when 06 => letter_data <= "0000100001011110000111111"; -- F
            when 07 => letter_data <= "1111110001110010000111111"; -- G
            when 08 => letter_data <= "1000110001111111000110001"; -- H
            when others => letter_data <= (others => '0');
        end case;
    end process;
    
    pixel <= letter_data((y*5)+x);
end rtl;
