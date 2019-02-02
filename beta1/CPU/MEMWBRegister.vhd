library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEMWBRegister is
	Port( clk : in std_logic;
			rst : in std_logic;
			FlushSignal : in std_logic; --when this is 1, at next rising edge, flush the control signals
			KeepSignal : in std_logic; --When this is 1, keep this register at next rising edge
			--forward signals
			--Signal for WB
			WB_Mux_In : in std_logic_vector(2 downto 0);
			WB_CWB_In : in std_logic;
			--
			WB_Mux_Out : out std_logic_vector(2 downto 0);
			WB_CWB_Out : out std_logic;
			--input
			PC_In : in std_logic_vector(15 downto 0); --this is the PC associated with this command
			Command_In : in std_logic_vector(15 downto 0); --the original command
			DM_In : in std_logic_vector(15 downto 0); --the DM result
			ALU_In : in std_logic_vector(15 downto 0); --ALU result
			ID_MuxC_In : in std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			--output
			WB_PC_Out : out std_logic_vector(15 downto 0); --this is the PC associated with this command
			WB_Command_Out : out std_logic_vector(15 downto 0); --the original command
			DM_Out : out std_logic_vector(15 downto 0);
			WB_ALU_Out : out std_logic_vector(15 downto 0);
			WB_MuxC_Out : out std_logic_vector(3 downto 0) --the result of ID_MuxC, writeback register
			);
end MEMWBRegister;

architecture Behavioral of MEMWBRegister is
begin
	process(clk, rst)
	begin		
		if (rst = '0') then
			WB_Mux_Out <= (others => '0');
			WB_CWB_Out <= '0';
			--
			WB_PC_Out <= (others => '0');
			WB_Command_Out <= (others => '0');
			DM_Out <= (others => '0');
			WB_ALU_Out <= (others => '0');
			WB_MuxC_Out <= (others => '0');
		elsif (clk'event and clk='1') then
			if (KeepSignal = '0') then
				if (FlushSignal = '0') then
					WB_Mux_Out <= WB_Mux_In;
					WB_CWB_Out <= WB_CWB_In;
				else
					WB_Mux_Out <= (others => '0');
					WB_CWB_Out <= '0';
				end if;
				WB_PC_Out <= PC_In;
				WB_Command_Out <= Command_In;
				DM_Out <= DM_In;
				WB_ALU_Out <= ALU_In;
				WB_MuxC_Out <= ID_MuxC_In;
			end if;
		end if;
	end process;
end Behavioral;
