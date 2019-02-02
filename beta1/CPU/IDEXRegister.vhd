library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDEXRegister is
	Port( clk : in std_logic;
			rst : in std_logic;
			FlushSignal : in std_logic; --when this is 1, at next rising edge, flush the control signals
			KeepSignal : in std_logic; --When this is 1, keep this register at next rising edge
			--forward signals
			--Signal for EX
			EX_MuxA_In : in std_logic_vector(2 downto 0);
			EX_MuxB_In : in std_logic_vector(2 downto 0);
			EX_ALU_In : in std_logic_vector(4 downto 0);
			--
			EX_MuxA_Out : out std_logic_vector(2 downto 0);
			EX_MuxB_Out : out std_logic_vector(2 downto 0);
			EX_ALU_Out : out std_logic_vector(4 downto 0);
			--Signal for MEM
			ME_DM_In : in std_logic_vector(2 downto 0);
			--
			ME_DM_Out : out std_logic_vector(2 downto 0);
			--Signal for WB
			WB_Mux_In : in std_logic_vector(2 downto 0);
			WB_CWB_In : in std_logic;
			--
			WB_Mux_Out : out std_logic_vector(2 downto 0);
			WB_CWB_Out : out std_logic;
			--input
			PC_In : in std_logic_vector(15 downto 0); --this is the PC associated with this command
			Command_In : in std_logic_vector(15 downto 0); --the original command
			adder_In : in std_logic_vector(15 downto 0); --the result of adder
			OA_In : in std_logic_vector(15 downto 0); --first result of registers
			OB_In : in std_logic_vector(15 downto 0); --second result of registers
			IMME_In : in std_logic_vector(15 downto 0); --the result of IMME
			ID_MuxC_In : in std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			ID_MuxA_In : in std_logic_vector(3 downto 0); --rx
			ID_MuxB_In : in std_logic_vector(3 downto 0); --ry
			--output
			EX_PC_Out : out std_logic_vector(15 downto 0); --this is the PC associated with this command
			EX_Command_Out : out std_logic_vector(15 downto 0); --the original command
			adder_Out : out std_logic_vector(15 downto 0); --the result of adder
			OA_Out : out std_logic_vector(15 downto 0); --first result of registers
			OB_Out : out std_logic_vector(15 downto 0); --second result of registers
			IMME_Out : out std_logic_vector(15 downto 0); --the result of IMME
			ID_MuxC_Out : out std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			ID_MuxA_Out : out std_logic_vector(3 downto 0); --rx
			ID_MuxB_Out : out std_logic_vector(3 downto 0) --ry
			);
end IDEXRegister;

architecture Behavioral of IDEXRegister is
begin
	process(clk, rst)
	begin		
		if (rst = '0') then
			EX_MuxA_Out <= (others => '1');
			EX_MuxB_Out <= (others => '1');
			EX_ALU_Out <= (others => '0');
			ME_DM_Out <= (others => '0');
			WB_Mux_Out <= (others => '0');
			WB_CWB_Out <= '0';
			--
			EX_PC_Out <= (others => '0');
			EX_Command_Out <= (others => '0');
			adder_Out <= (others => '0');
			OA_Out <= (others => '0');
			OB_Out <= (others => '0');
			IMME_Out <= (others => '0');
			ID_MuxC_Out <= (others => '0');
			ID_MuxA_Out <= (others => '0');
			ID_MuxB_Out <= (others => '0');
		elsif (clk'event and clk='1') then
			if (KeepSignal = '0') then
				if (FlushSignal = '0') then
					EX_MuxA_Out <= EX_MuxA_In;
					EX_MuxB_Out <= EX_MuxB_In;
					EX_ALU_Out <= EX_ALU_In;
					ME_DM_Out <= ME_DM_In;
					WB_Mux_Out <= WB_Mux_In;
					WB_CWB_Out <= WB_CWB_In;
					EX_Command_Out <= Command_In;
					ID_MuxA_Out <= ID_MuxA_In;
					ID_MuxB_Out <= ID_MuxB_In;
					ID_MuxC_Out <= ID_MuxC_In;
				else
					EX_MuxA_Out <= (others => '0');
					EX_MuxB_Out <= (others => '0');
					EX_ALU_Out <= (others => '0');
					ME_DM_Out <= (others => '0');
					WB_Mux_Out <= (others => '0');
					WB_CWB_Out <= '0';
					EX_Command_Out <= "0000100000000000";
					ID_MuxA_Out <= "1111";
					ID_MuxB_Out <= "1111";
					ID_MuxC_Out <= "1111";
				end if;
				EX_PC_Out <= PC_In;
				adder_Out <= adder_In;
				OA_Out <= OA_In;
				OB_Out <= OB_In;
				IMME_Out <= IMME_In;
				
			end if;
		end if;
	end process;
end Behavioral;
