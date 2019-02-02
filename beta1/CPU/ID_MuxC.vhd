library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use to generate the code of the write back register
entity ID_MuxC is
	Port( RC_in : in std_logic_vector(8 downto 0); --connect this with [10:2] in the instruction
			RC_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end ID_MuxC;

architecture Behavioral of ID_MuxC is
begin
	process(RC_in, control)
	begin
		case control is
			when "001" =>		--rx
				RC_out <= '0' & RC_in(8 downto 6);
			when "010" =>		--ry
				RC_out <= '0' & RC_in(5 downto 3);
			when "011" =>		--SP
				RC_out <= "1000";
			when "101" =>		--IH
				RC_out <= "1001";
			when "110" =>		--T
				RC_out <= "1010";
			when "111" =>
				RC_out <= '0' & RC_in(2 downto 0);
			when others =>		--Do not need write back
				RC_out <= "1111";
		end case;
	end process;
end Behavioral;
