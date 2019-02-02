library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX_MuxB is
	Port( OA_in : in std_logic_vector(15 downto 0);
			OB_in : in std_logic_vector(15 downto 0);
			IMME_in : in std_logic_vector(15 downto 0);
			PC_in : in std_logic_vector(15 downto 0); --connect with PC we record on ID/EX register
			-- forward
			ALU_MEM_in : in std_logic_vector(15 downto 0);
			ALU_WBMUX_in : in std_logic_vector(15 downto 0);
			-- end forward
			SB_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0);
			-- forward control
			forward_unit_control : in std_logic_vector(1 downto 0)
			);
end EX_MuxB;

architecture Behavioral of EX_MuxB is
begin
	process(OA_in, OB_in, IMME_in, PC_in, control, ALU_MEM_in, ALU_WBMUX_in, forward_unit_control)
	begin
		if (forward_unit_control = "00") then
		case control is
			when "001" =>		--choose OA_in
				SB_out <= OA_in;
			when "010" =>		--choose OB_in
				SB_out <= OB_in;
			when "011" =>		--choose IMME
				SB_out <= IMME_in;
			when "100" =>		--choose PC
				SB_out <= PC_in;
			
			when others =>		--Do not need RA
				SB_out <= (others => '0');
		end case;
		elsif (forward_unit_control = "01") then
			SB_out <= ALU_MEM_in;
		elsif (forward_unit_control = "10") then
			SB_out <= ALU_WBMUX_in;
		else
			SB_out <= (others => '0');
		end if;
	end process;
end Behavioral;
