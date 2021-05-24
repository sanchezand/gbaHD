-----------------------------------------------------------------------
-- Title: Controller Communication
-- Author: sanchezand
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity controllerComm is
  port(
    enable : in std_logic;
    latch : in std_logic;
    clk: in std_logic;
    dataIn : in std_logic;
    dataUpdate : out std_logic;
    dataOut : out std_logic_vector( 5 downto 0 )
  );
end controllerComm;

architecture rtl of controllerComm is

constant MAX_DATA : integer := 5; -- Amount of data in the payload-1
signal counter : integer := MAX_DATA;

begin
    dataUpdate <= '1' when counter=0 else '0';
    process(clk, latch, enable) is
    begin
        if enable='0' then
            dataOut <= (others => '0');
        elsif latch='1' then
            counter <= MAX_DATA;
        elsif falling_edge(clk) then
            dataOut(counter) <= dataIn;
            counter <= counter - 1;
        end if;
    end process;
end rtl;
