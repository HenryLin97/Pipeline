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

entity Forward_Unit is
	port(
		ExMemRd : in std_logic_vector(3 downto 0);
		MemWbRd : in std_logic_vector(3 downto 0);
		
		IdExReg_A : in std_logic_vector(3 downto 0);
		IdExReg_B : in std_logic_vector(3 downto 0);
		
		EX_MuxA_Out : in std_logic_vector(2 downto 0);
		EX_MuxB_Out : in std_logic_vector(2 downto 0);
		
		Forward_A : out std_logic_vector(1 downto 0);
		Forward_B : out std_logic_vector(1 downto 0);
		
		clk : in std_logic;
		rst : in std_logic
	);
end Forward_Unit;

architecture Behavioral of Forward_Unit is
begin
	--process(ExMemRd, MemWbRd, IdExReg_A, IdExReg_B, rst, EX_MuxA_Out, EX_MuxB_Out)
	process(clk, rst)
	begin
		if (rst = '0') then
			Forward_A <= "00";
			Forward_B <= "00";
		--else
		elsif(clk'event and clk='0') then
--			Forward_A <= "00";
--			Forward_B <= "00";
			if (IdExReg_A = ExMemRd) and (IdExReg_A /= "1111") and (EX_MuxA_Out = "001") then
				Forward_A <= "01";
			elsif (IdExReg_A = MemWbRd) and (IdExReg_A /= "1111") and (EX_MuxA_Out = "001") then
				Forward_A <= "10";
			elsif (IdExReg_B = ExMemRd) and (IdExReg_B /= "1111") and (EX_MuxA_Out = "010") then
				Forward_A <= "01";
			elsif (IdExReg_B = MemWbRd) and (IdExReg_B /= "1111") and (EX_MuxA_Out = "010") then
				Forward_A <= "10";
			else
				Forward_A <= "00";
			end if;
			
			if (IdExReg_B = ExMemRd) and (IdExReg_B /= "1111") and (EX_MuxB_Out = "010") then
				Forward_B <= "01";
			elsif (IdExReg_B = MemWbRd) and (IdExReg_B /= "1111") and (EX_MuxB_Out = "010") then
				Forward_B <= "10";
			else
				Forward_B <= "00";
			end if;
		end if;
		
	end process;

end Behavioral;
