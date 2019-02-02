----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:38:21 11/22/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	port(
		src_A       :  in STD_LOGIC_VECTOR(15 downto 0);
		src_B       :  in STD_LOGIC_VECTOR(15 downto 0);
		ALU_op		  :  in STD_LOGIC_VECTOR(4 downto 0);
		ALU_result  :  out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- 默认设为全0
		branch_Judge : out std_logic
	);
end ALU;

architecture Behavioral of ALU is
	shared variable tmp : std_logic_vector(15 downto 0);
	shared variable zero : std_logic_vector(15 downto 0) := "0000000000000000";
begin
	process(src_A , src_B , ALU_op)
	begin
		case ALU_op is 
			when "00001" => --  +
				ALU_result <= src_A + src_B;
				branch_Judge <= '0';
			when "00010" => --  -
				ALU_result <= src_A - src_B; -- A-B
				branch_Judge <= '0';
			when "00011" => --  AND
				ALU_result <= src_A and src_B;
				branch_Judge <= '0';
			when "00100" => --  OR
				ALU_result <= src_A or src_B;
				branch_Judge <= '0';
			when "00101" => -- NEG
				ALU_result <= zero - src_A;
				branch_Judge <= '0';
			when "00110" => --SLL
				tmp := src_A(15 downto 0);
				if (src_B = zero) then 
					ALU_result(15 downto 0) <= to_stdlogicvector(to_bitvector(tmp) sll 8);--left 8
				else 
					ALU_result <= to_stdlogicvector(to_bitvector(src_A) sll conv_integer(src_B));
				end if;
				branch_Judge <= '0';
			when "01100" => --SLLV
				ALU_result <= to_stdlogicvector(to_bitvector(src_A) sll conv_integer(src_B));
				branch_Judge <= '0';
			when "00111" => --  SRA
				tmp := src_A(15 downto 0);
				if (src_B = zero) then 
					ALU_result(15 downto 0) <= to_stdlogicvector(to_bitvector(tmp) sra 8);--left 8
				else 
					ALU_result <= to_stdlogicvector(to_bitvector(src_A) sra conv_integer(src_B));
				end if;
				branch_Judge <= '0';
			when "01101" => --SRAV
				ALU_result <= to_stdlogicvector(to_bitvector(src_A) sra conv_integer(src_B));
				branch_Judge <= '0';
			when "01000" => -- cmp , cmpi
				if (src_A = src_B) then 
					ALU_result <= "0000000000000000";
				else 
					ALU_result <= "0000000000000001";
				end if;
				branch_Judge <= '0';
			when "01001" => --BEQZ, BTEQZ
				--ALU_result  <= src_A - src_B; 
				if (src_A = zero) then
					branch_Judge <= '1';
				else 
					branch_Judge <= '0';
				end if;
			when "01010" => --B
				branch_Judge <= '1';
			when "01011" => --BNEZ
				--ALU_result  <= src_A - src_B; 
				if (src_A = zero) then
					branch_Judge <= '0';
				else 
					branch_Judge <= '1';
				end if;
			when "01110" => --src_A
				ALU_result <= src_A;
			when "01111" => --src_B
				ALU_result <= src_B;
				
			when others => ALU_result <= "0000000000000000";
				branch_Judge <= '0';
		end case;
	end process;

end Behavioral;
