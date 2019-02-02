library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCMUX is
	Port( PC_AddOne : in std_logic_vector(15 downto 0);
			ID_In : in std_logic_vector(15 downto 0);
			EX_In : in std_logic_vector(15 downto 0);
			OA_In : in std_logic_vector(15 downto 0);
			PCMuxOut : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
			);
end PCMUX;

architecture Behavioral of PCMUX is
begin
	process(PC_AddOne, ID_In, EX_In, OA_In, control)
	begin
		case control is
			when "001" =>		--choose PC_AddOne
				PCMuxOut <= PC_AddOne;
			when "010" =>		--choose ID_in
				PCMuxOut <= ID_In;
			when "011" =>		--choose EX_In
				PCMuxOut <= EX_In;
			when "100" =>		--choose OA_In
				PCMuxOut <= OA_In;
			when others =>
				PCMuxOut <= (others => '0');
		end case;
	end process;
end Behavioral;
