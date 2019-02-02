library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFIDRegister is
	Port( clk : in std_logic;
			rst : in std_logic;
			KeepSignal : in std_logic; --When this is 1, keep this register at next rising edge
			--input
			IM_PC : in std_logic_vector(15 downto 0); --this is the PC associated with this command
			IM_Command : in std_logic_vector(15 downto 0);
			PCAdder_PC : in std_logic_vector(15 downto 0);
			--output
			IM_Command_Out : out std_logic_vector(15 downto 0);
			IM_PC_Out : out std_logic_vector(15 downto 0);
			PCAdder_PC_Out : out std_logic_vector(15 downto 0)
			);
end IFIDRegister;

architecture Behavioral of IFIDRegister is
begin
	process(clk, rst)
	begin		
		if (rst = '0') then
			IM_PC_Out <= (others => '0');
			IM_Command_Out <= "0000100000000000";
			PCAdder_PC_Out <= (others => '0');
		elsif (clk'event and clk='1') then
			if (KeepSignal = '0') then
				IM_Command_Out <= IM_Command;
				IM_PC_Out <= IM_PC;
				PCAdder_PC_Out <= PCAdder_PC;
			end if;
		end if;
	end process;
end Behavioral;
