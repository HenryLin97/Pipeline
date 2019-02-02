library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WBMUX is
	Port( DM_in : in std_logic_vector(15 downto 0); --connect this with [10:5] in the instruction
			ADM_in : in std_logic_vector(15 downto 0);
			WBMUX_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end WBMUX;

architecture Behavioral of WBMUX is
begin
	process(DM_in, ADM_in, control)
	begin
		case control is
			when "001" =>		--RA(rx)
				WBMUX_out <= DM_in;
			when "010" =>		--RA(ry)
				WBMUX_out <= ADM_in;
			when others =>		--Do not need RA
				WBMUX_out <= (others=>'0');
		end case;
	end process;
end Behavioral;
