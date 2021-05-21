-----------------------------------------------------------------------
-- Title: OSD alphabet
-- Author: sanchezand
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity alphabet is
    Port ( letter : in integer range 0 to 37;
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
            when 05 => letter_data <= "1111100001111110000111111"; -- E
            when 06 => letter_data <= "0000100001011110000111111"; -- F
            when 07 => letter_data <= "1111110001111010000111111"; -- G
            when 08 => letter_data <= "1000110001111111000110001"; -- H
            when 09 => letter_data <= "1111100100001000010011111"; -- I
            when 10 => letter_data <= "1111110001100001000011100"; -- J
            when 11 => letter_data <= "1000101001001110100110001"; -- K
            when 12 => letter_data <= "1111100001000010000100001"; -- L
            when 13 => letter_data <= "1000110001101011101110001"; -- M
            when 14 => letter_data <= "1000111001101011001110001"; -- N
            when 15 => letter_data <= "0111010001100011000101110"; -- O
            when 16 => letter_data <= "0000100001011111000101111"; -- P
            when 17 => letter_data <= "0010011111100011000111111"; -- Q
            when 18 => letter_data <= "1000110001011111000101111"; -- R
            when 19 => letter_data <= "1111110000111110000111111"; -- S
            when 20 => letter_data <= "0010000100001000010011111"; -- T
            when 21 => letter_data <= "1111110001100011000110001"; -- U
            when 22 => letter_data <= "0010001010010101000110001"; -- V
            when 23 => letter_data <= "0101010101101011000110001"; -- W
            when 24 => letter_data <= "1000101010001000101010001"; -- X
            when 25 => letter_data <= "0010000100010101000110001"; -- Y
            when 26 => letter_data <= "1111100010001000100011111"; -- Z
            when 27 => letter_data <= "0111010011101011100101110"; -- 0
            when 28 => letter_data <= "0111000100001000011000100"; -- 1
            when 29 => letter_data <= "1111100001011101000001111"; -- 2
            when 30 => letter_data <= "1111110000011101000011111"; -- 3
            when 31 => letter_data <= "0100011111010010000100001"; -- 4
            when 32 => letter_data <= "0111110000011110000111111"; -- 5
            when 33 => letter_data <= "1111110001111110000111111"; -- 6
            when 34 => letter_data <= "0010000100010001000011111"; -- 7
            when 35 => letter_data <= "1111110001111111000111111"; -- 8
            when 36 => letter_data <= "1111110000111111000111111"; -- 9
            when 37 => letter_data <= "1111110001100011000111111"; -- OFF
            when 38 => letter_data <= "1111111111111111111111111"; -- ON
            when others => letter_data <= (others => '0');
        end case;
    end process;
    
    pixel <= letter_data((y*5)+x);
end rtl;
