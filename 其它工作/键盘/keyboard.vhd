----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:05:09 12/07/2018 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:53:33 12/04/2018 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Keyboard is
port (
	--һֱ���� ���������һ������
	datain, clkin : in std_logic ; -- PS2 clk and data
	fclk, rst : in std_logic ;  -- filter clock
	
	--iswork_KEYBOARD : in std_logic ; 
--	fok : out std_logic ;  -- data output enable signal
	--scancode : out std_logic_vector(7 downto 0) -- scan code signal output
	direction : out std_logic_vector(15 downto 0):="0000000000000001" -- 0001 �� 0010 �� 0100 �� 1000 ��
	);
end Keyboard ;

architecture rtl of Keyboard is
type state_type is (delay, start, d0, d1, d2, d3, d4, d5, d6, d7, parity, stop, finish) ;
signal data, clk, clk1, clk2, odd, fok : std_logic ; -- ë�̴����ڲ��ź�, oddΪ��żУ��
signal code : std_logic_vector(7 downto 0) ; 
signal state : state_type ;
signal scancode : std_logic_vector(7 downto 0);
begin
	clk1 <= clkin when rising_edge(fclk) ;
	clk2 <= clk1 when rising_edge(fclk) ;
	clk <= (not clk1) and clk2 ;
	
	data <= datain when rising_edge(fclk) ;
	
	odd <= code(0) xor code(1) xor code(2) xor code(3) 
		xor code(4) xor code(5) xor code(6) xor code(7) ;
	
	scancode <= code when fok = '1' ;
	
	process(rst, fclk)
	begin
		if rst = '0' then
			state <= delay ;
			code <= (others => '0') ;
			fok <= '0' ;
		elsif rising_edge(fclk) then
			fok <= '0' ;
			case state is 
				when delay =>
					state <= start ;
				when start =>
					if clk = '1' then
						if data = '0' then
							state <= d0 ;
						else
							state <= delay ;
						end if ;
					end if ;
				when d0 =>
					if clk = '1' then
						code(0) <= data ;
						state <= d1 ;
					end if ;
				when d1 =>
					if clk = '1' then
						code(1) <= data ;
						state <= d2 ;
					end if ;
				when d2 =>
					if clk = '1' then
						code(2) <= data ;
						state <= d3 ;
					end if ;
				when d3 =>
					if clk = '1' then
						code(3) <= data ;
						state <= d4 ;
					end if ;
				when d4 =>
					if clk = '1' then
						code(4) <= data ;
						state <= d5 ;
					end if ;
				when d5 =>
					if clk = '1' then
						code(5) <= data ;
						state <= d6 ;
					end if ;
				when d6 =>
					if clk = '1' then
						code(6) <= data ;
						state <= d7 ;
					end if ;
				when d7 =>
					if clk = '1' then
						code(7) <= data ;
						state <= parity ;
					end if ;
				WHEN parity =>
					IF clk = '1' then
						if (data xor odd) = '1' then
							state <= stop ;
						else
							state <= delay ;
						end if;
					END IF;

				WHEN stop =>
					IF clk = '1' then
						if data = '1' then
							state <= finish;
						else
							state <= delay;
						end if;
					END IF;

				WHEN finish =>
					state <= delay ;
					fok <= '1' ;
				when others =>
					state <= delay ;
			end case ; 
		end if ;
	end process ;
	
	--���·���
	process(scancode)
	begin
		if(scancode = "01110101")  then--75
			direction <= "0000000000000000";  --up
		elsif(scancode = "01101011") then--6B
			direction <= "0000000000000001";  --left
		elsif(scancode = "01110010") then
			direction <= "0000000000000010";  --down
		elsif(scancode = "01110100") then
			direction <= "0000000000000011";   --right
		end if;
	end process;
	
	
end rtl ;