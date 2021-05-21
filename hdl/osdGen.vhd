-----------------------------------------------------------------------
-- Title: Grid generator
-- Author: sanchezand
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.all;

entity osdGen is
    Port ( drawOSD : in STD_LOGIC;
           pixelX : in integer range 0 to 320;
           pixelY : in integer range 0 to 320;
           gridActive : in STD_LOGIC;
           smooth2x : in STD_LOGIC;
           smooth4x : in STD_LOGIC;
           nextPxl : out STD_LOGIC);
end osdGen;


architecture rtl of osdGen is

constant FONT_SIZE : integer := 5;
constant FONT_SEPARATION : integer := 1;
constant LINE_SEPARATION : integer := 2;
constant MAX_LETTERS : integer := 16;

type t_line is array (0 to MAX_LETTERS-1) of integer range 0 to 38;

signal current_line, current_line_y : integer;
signal current_letter, current_line_x : integer;
signal line_letter : integer;
signal selected_line : std_logic;
signal alphabet_pixel : std_logic;
 
signal gbahd_logo : t_line := (7, 2, 1, 8, 4, 0, 0, 0, 26, 23, 5, 14, 5, 18, 7, 25);

begin    
    selected_line <= '0';
    current_line <= pixelY / (FONT_SIZE+LINE_SEPARATION);
    current_line_y <= pixelY mod (FONT_SIZE+LINE_SEPARATION);
    
    line_letter <= pixelX / (FONT_SIZE+FONT_SEPARATION);
    current_letter <= gbahd_logo(line_letter);
    current_line_x <= pixelX mod (FONT_SIZE+FONT_SEPARATION);
    
    letter_alphabet : entity work.alphabet( rtl )
    port map(
        letter => current_letter,
        x => current_line_x,
        y => current_line_y,
        pixel => alphabet_pixel
     ); 
     
     nextPxl <= '0' when (line_letter>=MAX_LETTERS or current_line_y >= FONT_SIZE or current_line_x >= FONT_SIZE) else alphabet_pixel;
end rtl;