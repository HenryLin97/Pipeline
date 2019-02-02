----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:45:59 11/21/2016 
-- Design Name: 
-- Module Name:    ForwardController - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Forwarding_Unit is
	port(
		ExMemRd : in std_logic_vector(3 downto 0);   --
		MemWbRd : in std_logic_vector(3 downto 0);   --
		
		--ExMemRegWrite : in std_logic;
		--MemWbRegWrite : in std_logic;    --由"1111"判断没有源寄存器
		
		IdExALUsrcB : in std_logic;
--		IdExMemWrite : in std_logic;
		
		IdExReg_A : in std_logic_vector(3 downto 0);  --本条指令的源寄存器1
		IdExReg_B : in std_logic_vector(3 downto 0);  --本条指令的源寄存器2
		
		Forward_A : out std_logic_vector(1 downto 0);
		Forward_B : out std_logic_vector(1 downto 0);
	);
end Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is
begin
	process(ExMemRd, MemWbRd, IdExALUsrcB, IdExReg_A, IdExReg_B)
	begin
		if (IdExReg_A = ExMemRd) then
			Forward_A <= "01";
		elsif (IdExReg_A = MemWbRd) then
			Forward_A <= "10";
		else
			Forward_A <= "00";
		end if;
		
		if (IdExALUsrcB = '1') then		--SrcB是一个立即数，则不会产生冲突
			Forward_B <= "00";
		elsif (IdExALUsrcB = '0') then	--SrcB是一个寄存器值，则可能产生冲突
			if (IdExReg_B = ExMemRd) then
				Forward_B <= "01";
			elsif (IdExReg_B = MemWbRd) then
				Forward_B <= "10";
			else									--无冲突
				Forward_B <= "00";
			end if;
		end if;
		
--		if (IdExMemWrite = '1') then
--			if (IdExReg_B = ExMemRd) then
--				ForwardSW <= "01";
--			elsif (IdExReg_B = MemWbRd) then
--				ForwardSW <= "10";
--			else									--无冲突
--				ForwardSW <= "00";
--			end if;
--		else
--			ForwardSW <= "00";
--		end if;
		
	end process;

end Behavioral;
