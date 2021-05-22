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
constant FONT_SCALE : integer := 3;
constant FONT_SEPARATION : integer := 1;
constant LINE_SEPARATION : integer := 2;
constant MAX_LETTERS : integer := 16;

type t_line is array (0 to MAX_LETTERS-1) of integer range 0 to 38;

signal current_line, selected_line: integer range 0 to 14;
signal current_letter, current_line_x, current_line_y, current_line_y_temp : integer;
signal osdX, osdY : integer range 0 to 80;
signal line_letter : integer range 0 to 37;
signal alphabet_pixel, current_line_selected, next_line_selected, drawLetters : std_logic;

signal gbahd_logo : t_line :=           (07, 02, 01, 08, 04, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00);
signal watermark : t_line :=            (18, 01, 09, 26, 21, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00);
signal osd_pixel_grid : t_line :=       (16, 09, 24, 05, 12, 00, 07, 18, 09, 04, 00, 00, 00, 00, 00, 37);
signal osd_smoothing : t_line :=        (19, 13, 15, 15, 20, 08, 09, 14, 07, 00, 00, 00, 00, 00, 00, 38);
signal osd_close : t_line :=            (24, 00, 03, 12, 15, 19, 05, 00, 13, 05, 14, 21, 00, 00, 00, 00);

begin
    drawLetters <= '1' when pixelX > 2 else '0';
    osdX <= (pixelX-2) / FONT_SCALE when drawLetters='1' else 0;
    osdY <= pixelY / FONT_SCALE;
    
    osd_pixel_grid(15) <= 38 when gridActive='1' else 37;
    osd_smoothing(14) <= 
        29 when smooth2x='1' and smooth4x='0' else
        31 when smooth2x='0' and smooth4x='1' else
        14;
    osd_smoothing(15) <= 24 when smooth2x='1' or smooth4x='1' else 15;
    
    selected_line <= 1;
    current_line <= osdY / (FONT_SIZE+LINE_SEPARATION);
    current_line_y <= osdY mod (FONT_SIZE+LINE_SEPARATION);
    
    line_letter <= osdX / (FONT_SIZE+FONT_SEPARATION);
    current_line_x <= osdX mod (FONT_SIZE+FONT_SEPARATION);
    current_letter <= 
        0 when (drawLetters='0' or current_line_y=0) else
        gbahd_logo(line_letter) when current_line=0 
        else osd_pixel_grid(line_letter) when current_line=1 
        else osd_smoothing(line_letter) when current_line=2
        else osd_close(line_letter) when current_line=3
        else 0;
    
    current_line_y_temp <= 0 when current_line_y=0 else current_line_y-1;
    letter_alphabet : entity work.alphabet( rtl )
    port map(
        letter => current_letter,
        x => current_line_x,
        y => current_line_y_temp,
        pixel => alphabet_pixel
     ); 
     
     current_line_selected <= '1' when current_line = selected_line else '0';
     next_line_selected <= '1' when selected_line = current_line+1 else '0';
     
     nextPxl <= 
        '0' when (drawOSD = '0' or pixelX > 290)
        else current_line_selected when (current_line_y>FONT_SIZE)
        else current_line_selected when (line_letter>=MAX_LETTERS or current_line_x >= FONT_SIZE)
        else not alphabet_pixel when current_line_selected='1' else alphabet_pixel;
end rtl;