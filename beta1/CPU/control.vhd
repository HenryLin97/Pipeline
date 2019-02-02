library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--hazard detection unit should be responsible for jump instructions!
--hazard detection should set control signal for IF_MUX!
entity Control is
	Port( CommandIn : in std_logic_vector(15 downto 0);
			rst : in std_logic;
			--Signal for ID
			ID_MuxAOut : out std_logic_vector(2 downto 0);
			ID_MuxBOut : out std_logic_vector(2 downto 0);
			ID_MuxCOut : out std_logic_vector(2 downto 0);
			ID_IMMEOut : out std_logic_vector(2 downto 0);
			--Signal for EX
			EX_MuxAOut : out std_logic_vector(2 downto 0);
			EX_MuxBOut : out std_logic_vector(2 downto 0);
			EX_ALUOut : out std_logic_vector(4 downto 0);
			--Signal for MEM
			ME_DMOut : out std_logic_vector(2 downto 0);
			--Signal for WB
			WB_MuxOut : out std_logic_vector(2 downto 0);
			WB_CWB : out std_logic
			);
end Control;

architecture Behavioral of Control is
begin
	process(CommandIn, rst)
	begin
		if (rst = '0') then
			ID_MuxAOut <= "000";
			ID_MuxBOut <= "000";
			ID_MuxCOut <= "000";
			ID_IMMEOut <= "000";
			EX_MuxAOut <= "000";
			EX_MuxBOut <= "000";
			EX_ALUOut <= "00000";
			ME_DMOut <= "000";
			WB_MuxOut <= "000";
			WB_CWB <= '0';
		else
			case CommandIn(15 downto 11) is
				when "01001"=> --ADDIU
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --do not need
					ID_MuxCOut <= "001"; --rx
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "011"; --IMME
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --need write back
				when "01000"=> --ADDIU3
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no need
					ID_MuxCOut <= "010"; --ry
					ID_IMMEOut <= "101"; --[3:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "011"; --IMME
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --need write back
				when "01100"=> 
					case CommandIn(10 downto 8) is
						when "011"=> --ADDSP
							ID_MuxAOut <= "011"; --sp
							ID_MuxBOut <= "000"; --do not need
							ID_MuxCOut <= "011"; --sp
							ID_IMMEOut <= "010"; --[7:0]
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "011"; --IMME
							EX_ALUOut <= "00001"; --add
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --need write back
						when "000"=> --BTEQZ
							ID_MuxAOut <= "110"; --T
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "000"; --no
							ID_IMMEOut <= "010"; --[7:0]
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "000"; --no
							EX_ALUOut <= "01001"; --BTEQZ
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "000"; --no
							WB_CWB <= '0'; --no
						when "100"=> --MTSP
							ID_MuxAOut <= "010"; --ry
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "011"; --SP
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "000"; --no
							EX_ALUOut <= "01110"; --keep OA
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when others=>
					end case;
				when "11100"=> 
					if (CommandIn(1 downto 0) = "01") then --ADDU
						ID_MuxAOut <= "001"; --rx
						ID_MuxBOut <= "010"; --ry
						ID_MuxCOut <= "111"; --rz
						ID_IMMEOut <= "000"; --no need
						EX_MuxAOut <= "001"; --OA
						EX_MuxBOut <= "010"; --OB
						EX_ALUOut <= "00001"; --add
						ME_DMOut <= "000"; --no
						WB_MuxOut <= "010"; --down
						WB_CWB <= '1'; --need write back
					elsif (CommandIn(1 downto 0) = "11") then --SUBU
						ID_MuxAOut <= "001"; --rx
						ID_MuxBOut <= "010"; --ry
						ID_MuxCOut <= "111"; --rz
						ID_IMMEOut <= "000"; --no need
						EX_MuxAOut <= "001"; --OA
						EX_MuxBOut <= "010"; --OB
						EX_ALUOut <= "00010"; --sub
						ME_DMOut <= "000"; --no
						WB_MuxOut <= "010"; --down
						WB_CWB <= '1'; --need write back
					end if;
				when "11101"=>
					case CommandIn(4 downto 0) is
						when "01100"=> --AND
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "010"; --ry
							ID_MuxCOut <= "001"; --rx
							ID_IMMEOut <= "000"; --no need
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "010"; --OB
							EX_ALUOut <= "00011"; --and
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --need write back
						when "01101"=> --OR
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "010"; --ry
							ID_MuxCOut <= "001"; --rx
							ID_IMMEOut <= "000"; --no need
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "010"; --OB
							EX_ALUOut <= "00100"; --or
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --need write back
						when "01010"=> --CMP
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "010"; --ry
							ID_MuxCOut <= "110"; --T
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "010"; --OB
							EX_ALUOut <= "01000"; --CMP
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when "00011"=> --SLTU
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "010"; --ry
							ID_MuxCOut <= "110"; --T
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "010"; --OB
							EX_ALUOut <= "00110"; --?SLTU???need implement
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when "00110"=> --SRLV
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "010"; --ry
							ID_MuxCOut <= "010"; --ry
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "010"; --OB
							EX_ALUOut <= "00000"; --?SRLV???need implement
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when "00000"=> 
							if (CommandIn(7 downto 5) = "000") then --JR, handle this at ID, same as B
								ID_MuxAOut <= "001"; --rx
								ID_MuxBOut <= "000"; --no
								ID_MuxCOut <= "000"; --no
								ID_IMMEOut <= "000"; --no
								EX_MuxAOut <= "000"; --no
								EX_MuxBOut <= "000"; --no
								EX_ALUOut <= "00000"; --no
								ME_DMOut <= "000"; --no
								WB_MuxOut <= "000"; --no
								WB_CWB <= '0'; --no
							elsif (CommandIn(7 downto 5) = "010") then --MFPC
								ID_MuxAOut <= "000"; --no
								ID_MuxBOut <= "000"; --no
								ID_MuxCOut <= "001"; --rx
								ID_IMMEOut <= "000"; --no
								EX_MuxAOut <= "100"; --PC of the current instruction
								EX_MuxBOut <= "000"; --no
								EX_ALUOut <= "01110"; --keep OA
								ME_DMOut <= "000"; --no
								WB_MuxOut <= "010"; --down
								WB_CWB <= '1'; --yes
							else
								ID_MuxAOut <= "000";
								ID_MuxBOut <= "000";
								ID_MuxCOut <= "000";
								ID_IMMEOut <= "000";
								EX_MuxAOut <= "000";
								EX_MuxBOut <= "000";
								EX_ALUOut <= "00000";
								ME_DMOut <= "000";
								WB_MuxOut <= "000";
								WB_CWB <= '0';
							end if;
						when others=>
					end case;
				when "00010"=> --B
					ID_MuxAOut <= "000"; --no need
					ID_MuxBOut <= "000"; --no need
					ID_MuxCOut <= "000"; --no need
					ID_IMMEOut <= "001"; --[10:0]
					EX_MuxAOut <= "000"; --no need
					EX_MuxBOut <= "000"; --no need
					EX_ALUOut <= "00000"; --no need
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "00100"=> --BEQZ
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "000"; --no
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "000"; --no
					EX_ALUOut <= "01001"; --BEQZ
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "00101"=> --BNEZ
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "000"; --no
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "000"; --no
					EX_ALUOut <= "01011"; --BNEZ
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "01101"=> --LI
					ID_MuxAOut <= "000"; --no
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "001"; --rx
					ID_IMMEOut <= "110"; --[7:0],zero extend
					EX_MuxAOut <= "011"; --imme
					EX_MuxBOut <= "000"; --no
					EX_ALUOut <= "01110"; --keep A
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --yes
				when "10011"=> --LW
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "010"; --ry
					ID_IMMEOut <= "011"; --[4:0]
					EX_MuxAOut <= "001"; --rx
					EX_MuxBOut <= "011"; --imme
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "001"; --read
					WB_MuxOut <= "001"; --up
					WB_CWB <= '1'; --yes
				when "10010"=> --LW_SP
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "011"; --sp
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --rx
					EX_MuxBOut <= "011"; --imme
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "001"; --read
					WB_MuxOut <= "001"; --up
					WB_CWB <= '1'; --yes
				when "11110"=>
					case CommandIn(7 downto 0) is
						when "00000000"=> --MFIH
							ID_MuxAOut <= "101"; --IH
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "001"; --rx
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "000"; --no
							EX_ALUOut <= "01110"; --keep OA
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when "00000001"=> --MTIH
							ID_MuxAOut <= "001"; --rx
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "101"; --IH
							ID_IMMEOut <= "000"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "000"; --no
							EX_ALUOut <= "01110"; --keep OA
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when others=>
					end case;
				when "00001"=> --NOP
					ID_MuxAOut <= "000"; --no
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "000"; --no
					ID_IMMEOut <= "000"; --no
					EX_MuxAOut <= "000"; --no
					EX_MuxBOut <= "000"; --no
					EX_ALUOut <= "00000"; --no
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "00110"=>
					case CommandIn(1 downto 0) is
						when "00"=> --SLL
							ID_MuxAOut <= "010"; --ry
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "001"; --rx
							ID_IMMEOut <= "100"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "011"; --imme
							EX_ALUOut <= "00110"; --SLL
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when "11"=> --SRA
							ID_MuxAOut <= "010"; --ry
							ID_MuxBOut <= "000"; --no
							ID_MuxCOut <= "001"; --rx
							ID_IMMEOut <= "100"; --no
							EX_MuxAOut <= "001"; --OA
							EX_MuxBOut <= "011"; --imme
							EX_ALUOut <= "00111"; --SRA
							ME_DMOut <= "000"; --no
							WB_MuxOut <= "010"; --down
							WB_CWB <= '1'; --yes
						when others=>
					end case;
				when "11011"=> --SW
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "010"; --ry
					ID_MuxCOut <= "000"; --no
					ID_IMMEOut <= "011"; --[4:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "011"; --imme
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "010"; --write
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "11010"=> --SW_SP
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "011"; --sp
					ID_MuxCOut <= "000"; --no
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "011"; --imme
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "010"; --write
					WB_MuxOut <= "000"; --no
					WB_CWB <= '0'; --no
				when "00000"=> --ADDSP_3
					ID_MuxAOut <= "011"; --sp
					ID_MuxBOut <= "000"; --no need
					ID_MuxCOut <= "001"; --rx
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "011"; --IMME
					EX_ALUOut <= "00001"; --add
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --need write back
				when "01110"=> --CMPI
					ID_MuxAOut <= "001"; --rx
					ID_MuxBOut <= "000"; --no
					ID_MuxCOut <= "110"; --T
					ID_IMMEOut <= "010"; --[7:0]
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "010"; --OB
					EX_ALUOut <= "01000"; --CMP
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --yes
				when "01111"=> --MOVE
					ID_MuxAOut <= "010"; --ry
					ID_MuxBOut <= "000"; --no need
					ID_MuxCOut <= "001"; --rx
					ID_IMMEOut <= "000"; --no
					EX_MuxAOut <= "001"; --OA
					EX_MuxBOut <= "000"; --no
					EX_ALUOut <= "01110"; --keep OA
					ME_DMOut <= "000"; --no
					WB_MuxOut <= "010"; --down
					WB_CWB <= '1'; --need write back
				when others=>
			end case;
		end if;
	end process;
end Behavioral;