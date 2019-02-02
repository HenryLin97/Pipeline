library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EXMEMRegister is
	Port( clk : in std_logic;
			rst : in std_logic;
			FlushSignal : in std_logic; --when this is 1, at next rising edge, flush the control signals
			KeepSignal : in std_logic; --When this is 1, keep this register at next rising edge
			--forward signals
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
			ALU_In : in std_logic_vector(15 downto 0); --ALU result
			ID_MuxC_In : in std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			ID_MuxA_In : in std_logic_vector(3 downto 0); --rx
			ID_MuxB_In : in std_logic_vector(3 downto 0); --ry
			ID_OB_In : in std_logic_vector(15 downto 0);
			--hazard detect
			im_state_in : in std_logic_vector(4 downto 0);
			--output
			MEM_PC_Out : out std_logic_vector(15 downto 0); --this is the PC associated with this command
			MEM_Command_Out : out std_logic_vector(15 downto 0); --the original command
			MEM_ALU_Out : out std_logic_vector(15 downto 0);
			MEM_OB_Out : out std_logic_vector(15 downto 0);
			MEM_MuxC_Out : out std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			MEM_MuxA_Out : out std_logic_vector(3 downto 0); --rx
			MEM_MuxB_Out : out std_logic_vector(3 downto 0) --ry
			);
end EXMEMRegister;

architecture Behavioral of EXMEMRegister is
begin
	process(clk, rst)
	begin		
		if (rst = '0') then
			ME_DM_Out <= (others => '0');
			WB_Mux_Out <= (others => '0');
			WB_CWB_Out <= '0';
			--
			MEM_PC_Out <= (others => '0');
			MEM_Command_Out <= (others => '0');
			MEM_ALU_Out <= (others => '0');
			MEM_MuxC_Out <= (others => '0');
			MEM_MuxA_Out <= (others => '0');
			MEM_MuxB_Out <= (others => '0');
			MEM_OB_Out <= (others => '0');
		elsif (clk'event and clk='1') then
			if (KeepSignal = '0') then
				if (FlushSignal = '0') then
					ME_DM_Out <= ME_DM_In;
					WB_Mux_Out <= WB_Mux_In;
					WB_CWB_Out <= WB_CWB_In;
				else
					ME_DM_Out <= (others => '0');
					WB_Mux_Out <= (others => '0');
					WB_CWB_Out <= '0';
				end if;
				MEM_PC_Out <= PC_In;
				MEM_Command_Out <= Command_In;
				MEM_ALU_Out <= ALU_In;
				MEM_MuxC_Out <= ID_MuxC_In;
				MEM_MuxA_Out <= ID_MuxA_In;
				MEM_MuxB_Out <= ID_MuxB_In;
				--MEM_OB_Out <= ALU_In;
				MEM_OB_Out <= ID_OB_In;
			--hazard detect
			elsif (im_state_in = "00011") then
				ME_DM_Out <= "000";
			end if;
		end if;
	end process;
end Behavioral;
