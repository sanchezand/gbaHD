-----------------------------------------------------------------------
-- Title: Grid generator
-- Author: sanchezand
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.all;

entity osdGen is
    Port ( 
       drawOSD : in STD_LOGIC;
       pixelX : in integer range 0 to 320;
       pixelY : in integer range 0 to 320;
       controllerUpdate : in std_logic;
       controller : in std_logic_vector(5 downto 0);
       gridActive : out STD_LOGIC;
       smooth2x : out STD_LOGIC;
       smooth4x : out STD_LOGIC;
       nextPxl : out STD_LOGIC
   );
end osdGen;


architecture rtl of osdGen is

constant FONT_SIZE : integer := 5;
constant FONT_SCALE : integer := 3;
constant FONT_SEPARATION : integer := 1;
constant LINE_SEPARATION : integer := 2;
constant MAX_LETTERS : integer := 16;
constant MAX_LINES : integer := 3;

type t_line is array (0 to MAX_LETTERS-1) of integer range 0 to 40;
signal prev_controller : std_logic_vector(5 downto 0);

signal current_line : integer range 0 to 14;
signal selected_line: integer range 0 to MAX_LINES := 1;
signal current_letter, current_line_x, current_line_y, current_line_y_temp : integer;
signal osdX, osdY : integer range 0 to 80;
signal line_letter : integer range 0 to 40;
signal alphabet_pixel, current_line_selected, next_line_selected, drawLetters : std_logic;

signal gbahd_logo : t_line :=           (07, 02, 01, 08, 04, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00);
signal osd_pixel_grid : t_line :=       (16, 09, 24, 05, 12, 00, 07, 18, 09, 04, 00, 00, 00, 00, 00, 37);
signal osd_smoothing : t_line :=        (19, 13, 15, 15, 20, 08, 09, 14, 07, 00, 00, 00, 40, 00, 00, 39);
signal osd_credits : t_line :=          (03, 18, 05, 04, 09, 20, 19, 00, 00, 00, 00, 00, 00, 00, 00, 39);

signal opt_grid, opt_s2x, opt_s4x : std_logic;

begin
    drawLetters <= '1' when pixelX > 2 else '0';
    osdX <= (pixelX-2) / FONT_SCALE when drawLetters='1' else 0;
    osdY <= pixelY / FONT_SCALE;
    
    osd_pixel_grid(15) <= 38 when opt_grid='1' else 37;
    osd_smoothing(13) <= 
        29 when opt_s2x='1' and opt_s4x='0' else
        31 when opt_s2x='0' and opt_s4x='1' else
        14;
    osd_smoothing(14) <= 24 when opt_s2x='1' or opt_s4x='1' else 15;
    
    current_line <= osdY / (FONT_SIZE+LINE_SEPARATION);
    current_line_y <= osdY mod (FONT_SIZE+LINE_SEPARATION);
    
    line_letter <= osdX / (FONT_SIZE+FONT_SEPARATION);
    current_line_x <= osdX mod (FONT_SIZE+FONT_SEPARATION);
    current_letter <= 
        0 when (drawLetters='0' or current_line_y=0) else
        gbahd_logo(line_letter) when current_line=0 
        else osd_pixel_grid(line_letter) when current_line=1 
        else osd_smoothing(line_letter) when current_line=2
        else osd_credits(line_letter) when current_line=3
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
        
     process(controllerUpdate) is
     begin
        if(rising_edge(controllerUpdate)) then
            if(controller/=prev_controller) then
                if(controller(0)='1' and prev_controller(0)='0') then -- UP
                    if(selected_line>1) then
                        selected_line <= selected_line - 1;
                    end if;
                elsif(controller(1)='1' and prev_controller(1)='0') then -- DOWN
                    if(selected_line<MAX_LINES) then
                        selected_line <= selected_line + 1;
                    end if;
                elsif(controller(4)='1' and prev_controller(4)='0') then -- A
                    if(selected_line=1) then
                        opt_grid <= not opt_grid;
                    elsif(selected_line=2) then
                        if(opt_s2x='0' and opt_s4x='0') then
                            opt_s2x <= '1';
                            opt_s4x <= '0';
                        elsif(opt_s2x='1' and opt_s4x='0') then
                            opt_s2x <= '0';
                            opt_s4x <= '1';
                        elsif(opt_s2x='0' and opt_s4x='1') then
                            opt_s2x <= '0';
                            opt_s4x <= '0';
                        end if;
                    end if;
                end if;
                prev_controller <= controller;
            end if;
        end if;
     end process;
     
     gridActive <= opt_grid;
     smooth2x <= opt_s2x;
     smooth4x <= opt_s4x;
end rtl;