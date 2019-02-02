library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID_MuxB is
	Port( RB_in : in std_logic_vector(5 downto 0); --connect this with [10:5] in the instruction
			RB_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end ID_MuxB;

architecture Behavioral of ID_MuxB is
begin
	process(RB_in, control)
	begin
		case control is
			when "001" =>		--RB(rx)
				RB_out <= '0' & RB_in(5 downto 3);
			when "010" =>		--RB(ry)
				RB_out <= '0' & RB_in(2 downto 0);
			when "011" =>		--SP
				RB_out <= "1000";
			when "101" =>		--IH
				RB_out <= "1001";
			when "110" =>		--T
				RB_out <= "1010";
			when others =>		--Do not need RB
				RB_out <= "1111";
		end case;
	end process;
end Behavioral;
