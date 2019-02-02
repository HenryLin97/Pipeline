library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID_MuxA is
	Port( RA_in : in std_logic_vector(5 downto 0); --connect this with [10:5] in the instruction
			RA_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end ID_MuxA;

architecture Behavioral of ID_MuxA is
begin
	process(RA_in, control)
	begin
--		if (rst = '0') then
--			RA_out <= "1111";
--		else
		case control is
			when "001" =>		--RA(rx)
				RA_out <= '0' & RA_in(5 downto 3);
			when "010" =>		--RA(ry)
				RA_out <= '0' & RA_in(2 downto 0);
			when "011" =>		--SP
				RA_out <= "1000";
			when "101" =>		--IH
				RA_out <= "1001";
			when "110" =>		--T
				RA_out <= "1010";
			when others =>		--Do not need RA
				RA_out <= "1111";
		end case;
--		end if;
	end process;
end Behavioral;
