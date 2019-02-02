library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use to generate the code of the write back register
entity IMME is
	Port( IMME_in : in std_logic_vector(10 downto 0); --connect this with [10:0] in the instruction
			IMME_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end IMME;

architecture Behavioral of IMME is
shared variable sign : std_logic;
shared variable temp_num : std_logic_vector(15 downto 0);
begin
	process(IMME_in, control)
	begin
		case control is
			when "001" => --imme at [10:0]
				sign := IMME_in(10);
			when "010" => --imme at [7:0], sign extend
				sign := IMME_in(7);
			when "011" => --imme at [4:0]
				sign := IMME_in(4);
			when "100" => --imme at [4:2], zero extend
				sign := '0';
			when "101" => --imme at [3:0]
				sign := IMME_in(3);
			when "110" => --imme at [7:0], zero extend
				sign := '0';
			when others =>		--Do not need write back
				sign := '0';
		end case;
		temp_num := (others=>sign);
		case control is
			when "001" => --imme at [10:0]
				IMME_out <= temp_num(15 downto 11) & IMME_in(10 downto 0);
			when "010" => --imme at [7:0]
				IMME_out <= temp_num(15 downto 8) & IMME_in(7 downto 0);
			when "011" => --imme at [4:0]
				IMME_out <= temp_num(15 downto 5) & IMME_in(4 downto 0);
			when "100" => --imme at [4:2]
				IMME_out <= temp_num(15 downto 3) & IMME_in(4 downto 2);
			when "101" => --imme at [3:0]
				IMME_out <= temp_num(15 downto 4) & IMME_in(3 downto 0);
			when "110" => --imme at [7:0]
				IMME_out <= temp_num(15 downto 8) & IMME_in(7 downto 0);
			when others =>		--Do not need write back
				IMME_out <= (others=>'0');
		end case;
	end process;
end Behavioral;
