library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--1
entity cpu is
	port(
			rst : in std_logic; --reset
			clk_50 : in std_logic; --时钟源  默认为50M  可以通过修改绑定管脚来改变
			clk_hand : in std_logic;
			--opt : in std_logic;	--选择输入时钟（为手动或者50M）
			
			
			--串口
			dataReady : in std_logic;   
			tbre : in std_logic;
			tsre : in std_logic;
			-------
			r : in std_logic_vector(15 downto 0); --switch
			-------
			rdn : inout std_logic;
			wrn : inout std_logic;
			
			--RAM1  存放数据
			ram1En : out std_logic;
			ram1We : out std_logic;
			ram1Oe : out std_logic;
			ram1Data : inout std_logic_vector(15 downto 0);
			ram1Addr : out std_logic_vector(17 downto 0);
			
			--RAM2 存放程序和指令
			ram2En : out std_logic;
			ram2We : out std_logic;
			ram2Oe : out std_logic;
			ram2Data : inout std_logic_vector(15 downto 0);
			ram2Addr : out std_logic_vector(17 downto 0);
			
			
			--display_im : out std_logic_vector(15 downto 0);
			--display_dm : out std_logic_vector(15 downto 0);
			
			--used for simulation! Comment it when actual use.
--			r0Out, r1Out, r2Out,r3Out,r4Out,r5Out,r6Out,r7Out : out std_logic_vector(15 downto 0);
--			dataT : out std_logic_vector(15 downto 0);
--			dataSP : out std_logic_vector(15 downto 0);
--			dataIH : out std_logic_vector(15 downto 0);
			--end
			
			--debug  digit1、digit2显示PC值，led显示当前指令的编码
			digit1 : out std_logic_vector(6 downto 0);	--7位数码管1
			digit2 : out std_logic_vector(6 downto 0);	--7位数码管2
			led : out std_logic_vector(15 downto 0)
			
	);
			
end cpu;

architecture Behavioral of cpu is
	
	component Control
		port (
			CommandIn : in std_logic_vector(15 downto 0);
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
	end component;
	
	component HazardDetection
		port(
			rst : in std_logic;
			clk : in std_logic;
			IFID_CommandIn : in std_logic_vector(15 downto 0); --Command stored at IFID register
			IDEX_CommandIn : in std_logic_vector(15 downto 0); --Command stored at IDEX register
			EXMEM_CommandIn : in std_logic_vector(15 downto 0); --Command stored at EXMEM register
			MEMWB_CommandIn : in std_logic_vector(15 downto 0); --Command stored at MEMWB register
			IM_Stop : in std_logic; --when this is 1, IM needs one more step to fetch instruction
			DM_Stop : in std_logic; --when this is 1, DM needs one more step to fetch data
			Branch_Judge : in std_logic;
			---------temporary solution: implement the alu and forward unit 
			OA_in : in std_logic_vector(15 downto 0);
			IdExReg_A : in std_logic_vector(3 downto 0);
			ExMemRd : in std_logic_vector(3 downto 0);
			MemWbRd : in std_logic_vector(3 downto 0);
			ALU_MEM_in : in std_logic_vector(15 downto 0);
			ALU_WBMUX_in : in std_logic_vector(15 downto 0);
			---------
			---------
			PC_Out : out std_logic; --when this is 1, keep PC at next round
			PCMUX_Out : out std_logic_vector(2 downto 0);
			IFID_Keep : out std_logic;
			IDEX_Keep : out std_logic;
			IDEX_Flush : out std_logic;
			EXMEM_Keep : out std_logic;
			EXMEM_Flush : out std_logic;
			MEMWB_Keep : out std_logic;
			MEMWB_Flush : out std_logic;
			im_state : out std_logic_vector(4 downto 0);
			im_keep : out std_logic
		);
	end component;
	
	component PCAdder
		port(
			adderIn : in std_logic_vector(15 downto 0);
			PCadderOut : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component PC
		port(
			rst,clk : in std_logic;
			PCKeep : in std_logic;
			PCIn : in std_logic_vector(15 downto 0);
			PCOut : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component PCMUX
		port(
			PC_AddOne : in std_logic_vector(15 downto 0);
			ID_In : in std_logic_vector(15 downto 0);
			EX_In : in std_logic_vector(15 downto 0);
			OA_In : in std_logic_vector(15 downto 0);
			PCMuxOut : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);
	end component;
	
	component IFIDRegister
		port(
			clk : in std_logic;
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
	end component;
	
	component ID_MuxA
		port(
			RA_in : in std_logic_vector(5 downto 0); --connect this with [10:5] in the instruction
			RA_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);
	end component;
	
	component ID_MuxB
		port(
			RB_in : in std_logic_vector(5 downto 0); --connect this with [10:5] in the instruction
			RB_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);
	end component;
	
	component ID_MuxC
		port(
			RC_in : in std_logic_vector(8 downto 0); --connect this with [10:2] in the instruction
			RC_out : out std_logic_vector(3 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);
	end component;
	
	component IMME
		port(
			IMME_in : in std_logic_vector(10 downto 0); --connect this with [10:0] in the instruction
			IMME_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);
	end component;
	
	component ID_Adder
		port(
			adderIn1 : in std_logic_vector(15 downto 0);
			adderIn2 : in std_logic_vector(15 downto 0);
			adderOut : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component registers
		port(
			clk : in std_logic;
			rst : in std_logic;
			RA : in std_logic_vector(3 downto 0);
			RB : in std_logic_vector(3 downto 0);
			WriteReg : in std_logic_vector(3 downto 0);
			WriteData : in std_logic_vector(15 downto 0);
			--out
			OA : out std_logic_vector(15 downto 0);
			OB : out std_logic_vector(15 downto 0);
			--used for simulation! comment it when use
			r0Out, r1Out, r2Out,r3Out,r4Out,r5Out,r6Out,r7Out : out std_logic_vector(15 downto 0);
			dataT : out std_logic_vector(15 downto 0);
			dataSP : out std_logic_vector(15 downto 0);
			dataIH : out std_logic_vector(15 downto 0);
			--control signals
			CWB : in std_logic --if write back needs to be implement
		);
	end component;
	
	component IDEXRegister
		port(
			clk : in std_logic;
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
	end component;
	
	component ALU
		port(
			src_A       :  in STD_LOGIC_VECTOR(15 downto 0);
			src_B       :  in STD_LOGIC_VECTOR(15 downto 0);
			ALU_op		  :  in STD_LOGIC_VECTOR(4 downto 0);
			ALU_result  :  out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- 榛樿璁句负鍏
			branch_Judge : out std_logic
		);
	end component;
	
	component EX_MUXA
		port(
			OA_in : in std_logic_vector(15 downto 0);
			OB_in : in std_logic_vector(15 downto 0);
			IMME_in : in std_logic_vector(15 downto 0);
			PC_in : in std_logic_vector(15 downto 0); --connect with PC we record on ID/EX register
			-- forward
			ALU_MEM_in : in std_logic_vector(15 downto 0);
			ALU_WBMUX_in : in std_logic_vector(15 downto 0);
			-- end forward
			SA_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0);
			-- forward control
			forward_unit_control : in std_logic_vector(1 downto 0)
		);
	end component;
	
	component EX_MUXB
		Port( 
			OA_in : in std_logic_vector(15 downto 0);
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
	end component;
	
	component EXMEMRegister
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
			im_state_in : in std_logic_vector(4 downto 0);
			--output
			MEM_PC_Out : out std_logic_vector(15 downto 0); --this is the PC associated with this command
			MEM_Command_Out : out std_logic_vector(15 downto 0); --the original command
			MEM_ALU_Out : out std_logic_vector(15 downto 0);
			MEM_MuxC_Out : out std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			MEM_MuxA_Out : out std_logic_vector(3 downto 0); --rx
			MEM_MuxB_Out : out std_logic_vector(3 downto 0); --ry
			MEM_OB_Out : out std_logic_vector(15 downto 0)
		);
	end component;	
		
	component WBMUX
		Port( 
			DM_in : in std_logic_vector(15 downto 0); --connect this with [10:5] in the instruction
			ADM_in : in std_logic_vector(15 downto 0);
			WBMUX_out : out std_logic_vector(15 downto 0);
			--control signal
			control : in std_logic_vector(2 downto 0)
		);	
	end component;
	
	component MEMWBRegister
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
	end component;
	
	component MemoryUnit
		Port( clk : in std_logic;
			rst : in std_logic;
			keep_im : in std_logic;
			--DM
			dmControl : in std_logic_vector(2 downto 0);-- 001 读 010 写
			--dmWrite: in std_logic; --用0表示需要写入对应的ram
			--dmRead : in std_logic; --用0表示需要读取对应的ram
			dmAddr : in std_logic_vector(15 downto 0); --输入ram用的地址，注意包括串口用的特殊地址
			dmIn : in std_logic_vector(15 downto 0);		--写内存时，要写入ram1的数据
			dmOut : out std_logic_vector(15 downto 0);	--读DM时，读出来的数据/读出的串口状态
			--IM
			--WriteIM : in std_logic;
			--imRead : in std_logic;
			imAddr : in std_logic_vector(15 downto 0);
			--imIn:	in std_logic_vector(15 downto 0);
			imOut:	out std_logic_vector(15 downto 0);
			Memory_PCOut: out std_logic_vector(15 downto 0);
			--UART控制信号  
			ram1_oe, ram1_we, ram1_en : out STD_LOGIC;
			ram2_oe, ram2_we, ram2_en : out STD_LOGIC;
			ram1_addr, ram2_addr : out STD_LOGIC_VECTOR(17 downto 0); --两个ram的地址总线
			ram1_data, ram2_data : inout STD_LOGIC_VECTOR(15 downto 0); --两个ram的数据总线
			data_ready : in std_logic;
			tbre : in std_logic;
			tsre : in std_logic;
			wrn : out std_logic;
			rdn : out std_logic;
			--调试信号
			display_im : out std_logic_vector(15 downto 0);
			display_dm : out std_logic_vector(15 downto 0);
			--额外控制信号
			--dm_data_ready : out std_logic;
			--im_data_ready : out std_logic;
			stall_im : in std_logic;
			stall_dm : in std_logic;
			flush : in std_logic;
			--额外输出
			req_stall_im :out std_logic;
			req_stall_dm :out std_logic
		);
	end component;
	
	component Forward_Unit
		port(
			ExMemRd : in std_logic_vector(3 downto 0);
			MemWbRd : in std_logic_vector(3 downto 0);
			
			IdExReg_A : in std_logic_vector(3 downto 0);
			IdExReg_B : in std_logic_vector(3 downto 0);
			
			Forward_A : out std_logic_vector(1 downto 0);
			Forward_B : out std_logic_vector(1 downto 0);
			
			--
			EX_MuxA_Out : in std_logic_vector(2 downto 0);
			EX_MuxB_Out : in std_logic_vector(2 downto 0);
			--
			
			clk : in std_logic;
			rst : in std_logic
		);
	end component;
	
	component CLK_Unit
		port(	rst,clk_in : in std_logic;
			clk_out : out std_logic
			);
	end component;
		
	--以下的signal都是"全局变量"，来自所有component的out
			-------Control
	signal	ID_MuxAOut : std_logic_vector(2 downto 0);
	signal		ID_MuxBOut : std_logic_vector(2 downto 0);
	signal		ID_MuxCOut : std_logic_vector(2 downto 0);
	signal		ID_IMMEOut : std_logic_vector(2 downto 0);
			--Signal for EX
	signal		EX_MuxAOut : std_logic_vector(2 downto 0);
	signal		EX_MuxBOut : std_logic_vector(2 downto 0);
	signal	EX_ALUOut : std_logic_vector(4 downto 0);
			--Signal for MEM
	signal		ME_DMOut : std_logic_vector(2 downto 0);
			--Signal for WB
	signal		WB_MuxOut : std_logic_vector(2 downto 0);
	signal		WB_CWB : std_logic;
			-------Hazard Detection
	signal		PC_Out : std_logic; --when this is 1, keep PC at next round
	signal		PCMUX_Out : std_logic_vector(2 downto 0);
	signal		IFID_Keep : std_logic;
	signal		IDEX_Keep : std_logic;
	signal		IDEX_Flush : std_logic;
	signal		EXMEM_Keep : std_logic;
	signal		EXMEM_Flush : std_logic;
	signal		MEMWB_Keep : std_logic;
	signal	MEMWB_Flush : std_logic;
	signal		im_state : std_logic_vector(4 downto 0);
			-----PCAdder
	signal		PCadderOut : std_logic_vector(15 downto 0);
			-----PC
	signal		PCOut : std_logic_vector(15 downto 0);
			-----PCMUX
	signal		PCMuxOut : std_logic_vector(15 downto 0);
			-----IFIDRegister
	signal		IM_Command_Out : std_logic_vector(15 downto 0);
	signal		IM_PC_Out : std_logic_vector(15 downto 0);
	signal		PCAdder_PC_Out : std_logic_vector(15 downto 0);
			-----
	signal		RA_out : std_logic_vector(3 downto 0);
			-----
	signal	RB_out : std_logic_vector(3 downto 0);
			-----
	signal	RC_out : std_logic_vector(3 downto 0);
			-----
	signal		IMME_out : std_logic_vector(15 downto 0);
			-----
	signal		adderOut : std_logic_vector(15 downto 0);
			-----
	signal		OA : std_logic_vector(15 downto 0);
	signal		OB : std_logic_vector(15 downto 0);
	--used for simulation! Comment it when actual use.
	signal		r0Out, r1Out, r2Out,r3Out,r4Out,r5Out,r6Out,r7Out : std_logic_vector(15 downto 0);
	signal		dataT :  std_logic_vector(15 downto 0);
	signal		dataSP :  std_logic_vector(15 downto 0);
	signal		dataIH :  std_logic_vector(15 downto 0);
			--end
			-----IDEXRegister
	signal		EX_MuxA_Out : std_logic_vector(2 downto 0);
	signal		EX_MuxB_Out : std_logic_vector(2 downto 0);
	signal		EX_ALU_Out : std_logic_vector(4 downto 0);
	signal	ME_DM_Out0 : std_logic_vector(2 downto 0);
	signal		WB_Mux_Out0 : std_logic_vector(2 downto 0);
	signal		WB_CWB_Out0 : std_logic;
	signal		EX_PC_Out : std_logic_vector(15 downto 0); --this is the PC associated with this command
	signal		EX_Command_Out : std_logic_vector(15 downto 0); --the original command
	signal		adder_Out : std_logic_vector(15 downto 0); --the result of adder
	signal		OA_Out : std_logic_vector(15 downto 0); --first result of registers
	signal		OB_Out : std_logic_vector(15 downto 0); --second result of registers
	signal		EX_IMME_Out : std_logic_vector(15 downto 0); --the result of IMME
	signal		ID_MuxC_Out : std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
	signal		ID_MuxA_Out : std_logic_vector(3 downto 0); --rx
	signal		ID_MuxB_Out : std_logic_vector(3 downto 0); --ry
			-------ALU
	signal		ALU_result  :   STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- 榛樿璁句负鍏
	signal		branch_Judge : std_logic;
			-------
	signal		SA_out : std_logic_vector(15 downto 0);
			-------
	signal		SB_out : std_logic_vector(15 downto 0);
			-------EXMEM
	signal		ME_DM_Out1 : std_logic_vector(2 downto 0);
	signal		WB_Mux_Out1 : std_logic_vector(2 downto 0);
	signal		WB_CWB_Out1 : std_logic;
	signal		MEM_PC_Out : std_logic_vector(15 downto 0); --this is the PC associated with this command
	signal		MEM_Command_Out : std_logic_vector(15 downto 0); --the original command
	signal		MEM_ALU_Out : std_logic_vector(15 downto 0);
	signal		MEM_MuxC_Out : std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
	signal		MEM_MuxA_Out : std_logic_vector(3 downto 0); --rx
	signal		MEM_MuxB_Out : std_logic_vector(3 downto 0); --ry
	signal		MEM_OB_Out	: std_logic_vector(15 downto 0);
			------WBMUX
	signal		WBMUX_out : std_logic_vector(15 downto 0);
			------MEMWB
	signal		WB_Mux_Out2 : std_logic_vector(2 downto 0);
	signal		WB_CWB_Out2 : std_logic;
	signal		WB_PC_Out : std_logic_vector(15 downto 0); --this is the PC associated with this command
	signal		WB_Command_Out : std_logic_vector(15 downto 0); --the original command
	signal		DM_Out : std_logic_vector(15 downto 0);
	signal		WB_ALU_Out : std_logic_vector(15 downto 0);
	signal		WB_MuxC_Out : std_logic_vector(3 downto 0); --the result of ID_MuxC, writeback register
			-------MemoryUnit
	signal		imOut:	std_logic_vector(15 downto 0);
	signal		Memory_PCOut: std_logic_vector(15 downto 0);
	signal		dmOut : std_logic_vector(15 downto 0);	--读DM时，读出来的数据/读出的串口状态
	signal		display_im : std_logic_vector(15 downto 0);
	signal      display_dm : std_logic_vector(15 downto 0);
			--UART控制信号  
	signal		req_stall_im : std_logic;
	signal		req_stall_dm : std_logic;
	signal		zero_signal : std_logic := '0';
			------forward unit
	signal		Forward_A : std_logic_vector(1 downto 0);
	signal		Forward_B : std_logic_vector(1 downto 0);
	signal		im_keep : std_logic;
		--------clk_Unit
	signal		clk_out : std_logic;
	--dcm
	shared variable show_state : integer range 0 to 100 := 0;
	shared variable temp_state : integer range 0 to 100 := 0;
	
	
begin
	u1 : PC
	port map(	
			rst => rst,
			clk => clk_hand,
			PCKeep => PC_Out,
			PCIn => PCMuxOut,
			PCOut => PCOut
	);
	
	u2 : PCAdder
	port map( 
			adderIn => PCOut,
			PCadderOut => PCadderOut
	);
	
	u3 : 	IFIDRegister
	port map(
			rst => rst,
			clk => clk_hand,
			KeepSignal => IFID_Keep,
			IM_PC => Memory_PCOut,
			IM_Command => imOut,
			PCAdder_PC => PCAdderOut,
			IM_Command_Out =>IM_Command_Out,
			IM_PC_Out => IM_PC_out,
			PCAdder_PC_Out => PCAdder_PC_out
		);
	
	u4 :	PCMUX
	port map(
			PC_AddOne => PCadderOut,
			ID_In => adderOut,
			EX_In => adder_Out,
			OA_In => OA,
			PCMuxOut => PCMuxOut,
			--control signal
			control => PCMUX_Out
		);
	
	u5 : ID_MuxA
	port map(
			RA_in => IM_Command_Out(10 downto 5),
			RA_out => RA_out,
			--control signal
			control => ID_MuxAOut
		);
	
	u6 : ID_MuxB
	port map(
			RB_in => IM_Command_Out(10 downto 5),
			RB_out => RB_out,
			--control signal
			control => ID_MuxBOut
		);
	
	u7 : ID_MuxC
	port map(
			RC_in => IM_Command_Out(10 downto 2),
			RC_out => RC_Out,
			--control signal
			control => ID_MuxCOut
		);
	
	u8 : IMME
	port map(
			IMME_in => IM_Command_Out(10 downto 0),
			IMME_out => IMME_out,
			--control signal
			control => ID_IMMEOut
		);
	
	u9 : registers
	port map(
			clk => clk_hand,
			rst => rst,
			RA => RA_Out,
			RB => RB_Out,
			WriteReg => WB_MuxC_Out,
			WriteData => WBMUX_Out,
			--out
			OA => OA,
			OB => OB,
			--control signals
			CWB => WB_CWB_Out2,
			--used for simulation!
			r0Out => r0Out, 
			r1Out => r1Out, 
			r2Out => r2Out,
			r3Out => r3Out,
			r4Out => r4Out,
			r5Out => r5Out,
			r6Out => r6Out,
			r7Out => r7Out,
			dataT => dataT,
			dataSP => dataSP,
			dataIH => dataIH
		);
	
	u10 : ID_Adder
	port map(
			adderIn1 => IM_PC_Out,
			adderIn2 => IMME_Out,
			adderOut => adderOut
	);
	
	u11 : IDEXRegister
	port map(
			clk => clk_hand,
			rst => rst,
			FlushSignal => IDEX_Flush,
			KeepSignal => IDEX_Keep,
			EX_MuxA_In => EX_MuxAOut,
			EX_MuxB_In => EX_MuxBOut,
			EX_ALU_In => EX_ALUOut,
			EX_MuxA_Out => EX_MuxA_Out,
			EX_MuxB_Out => EX_MuxB_Out,
			EX_ALU_Out => EX_ALU_Out,
			--Signal for MEM
			ME_DM_In => ME_DMOut,
			--
			ME_DM_Out => ME_DM_Out0,
			--Signal for WB
			WB_Mux_In => WB_MuxOut,
			WB_CWB_In => WB_CWB,
			--
			WB_Mux_Out => WB_Mux_out0,
			WB_CWB_Out => WB_CWB_Out0,
			--input
			PC_In => IM_PC_Out, --this is the PC associated with this command
			Command_In => IM_Command_Out, --the original command
			adder_In => adderOut, --the result of adder
			OA_In => OA, --first result of registers
			OB_In => OB, --second result of registers
			IMME_In => IMME_out, --the result of IMME
			ID_MuxC_In => RC_out, --the result of ID_MuxC, writeback register
			ID_MuxA_In => RA_out, --rx
			ID_MuxB_In => RB_out, --ry
			--output
			EX_PC_Out => EX_PC_Out, --this is the PC associated with this command
			EX_Command_Out => EX_Command_Out, --the original command
			adder_Out => adder_Out, --the result of adder
			OA_Out => OA_Out, --first result of registers
			OB_Out => OB_Out, --second result of registers
			IMME_Out => EX_IMME_Out, --the result of IMME
			ID_MuxC_Out => ID_MuxC_Out, --the result of ID_MuxC, writeback register
			ID_MuxA_Out => ID_MuxA_Out, --rx
			ID_MuxB_Out => ID_MuxB_Out --ry
	);
	
	u12 : EX_MuxA
	port map(
			OA_in => OA_Out,
			OB_in => OB_Out,
			IMME_in => EX_IMME_Out,
			PC_in => EX_PC_Out, --connect with PC we record on ID/EX register
			SA_out => SA_out,
			ALU_MEM_in => MEM_ALU_Out,
			ALU_WBMUX_in => WBMUX_out,
			--control signal
			control => EX_MuxA_Out,
			forward_unit_control => Forward_A
	);
	
	u13 : EX_MuxB
	port map(
			OA_in => OA_Out,
			OB_in => OB_Out,
			IMME_in => EX_IMME_Out,
			PC_in => EX_PC_Out, --connect with PC we record on ID/EX register
			SB_out => SB_out,
			ALU_MEM_in => MEM_ALU_Out,
			ALU_WBMUX_in => WBMUX_out,
			--control signal
			control => EX_MuxB_Out,
			forward_unit_control => Forward_B
	);
	
	u14 : ALU
	port map(
			src_A  => SA_Out,
			src_B       => SB_Out,
			ALU_op		  => EX_ALU_Out,
			ALU_result  => ALU_result,
			branch_Judge => branch_Judge
	);
	
	u15 : EXMEMRegister
	port map(
			clk => clk_hand,
			rst => rst,
			im_state_in => im_state,
			FlushSignal => EXMEM_Flush, --when this is 1, at next rising edge, flush the control signals
			KeepSignal => EXMEM_Keep, --When this is 1, keep this register at next rising edge
			--forward signals
			--Signal for MEM
			ME_DM_In => ME_DM_Out0,
			--
			ME_DM_Out => ME_DM_Out1,
			--Signal for WB
			WB_Mux_In => WB_Mux_Out0,
			WB_CWB_In => WB_CWB_Out0,
			--
			WB_Mux_Out => WB_Mux_Out1,
			WB_CWB_Out => WB_CWB_Out1,
			--input
			PC_In => EX_PC_Out, --this is the PC associated with this command
			Command_In => EX_Command_Out, --the original command
			ALU_In => ALU_result, --ALU result
			ID_MuxC_In => ID_MuxC_Out, --the result of ID_MuxC, writeback register
			ID_MuxA_In => ID_MuxA_Out, --rx
			ID_MuxB_In => ID_MuxB_Out, --ry
			ID_OB_In => OB_Out,
			--output
			MEM_PC_Out => MEM_PC_Out, --this is the PC associated with this command
			MEM_Command_Out => MEM_Command_Out, --the original command
			MEM_ALU_Out => MEM_ALU_Out,
			MEM_MuxC_Out => MEM_MuxC_Out, --the result of ID_MuxC, writeback register
			MEM_MuxA_Out => MEM_MuxA_Out, --rx
			MEM_MuxB_Out => MEM_MuxB_Out, --ry
			MEM_OB_Out => MEM_OB_Out
	);
	
	u16 : MemoryUnit
	port map(
			clk => clk_hand,
			rst => rst,
			keep_im => im_keep,
			--DM
			dmControl => ME_DM_Out1,-- 001 读 010 写
			dmAddr => MEM_ALU_Out, --输入ram用的地址，注意包括串口用的特殊地址
			dmIn => MEM_OB_Out,		--写内存时，要写入ram1的数据
			dmOut => dmOut,	--读DM时，读出来的数据/读出的串口状态
			--IM
			--WriteIM : in std_logic;
			--imRead : in std_logic;
			imAddr => PCOut,
			--imIn:	in std_logic_vector(15 downto 0);
			imOut	=> imOut,
			Memory_PCOut => Memory_PCOut,
			--UART控制信号  
			ram1_oe => ram1Oe, 
			ram1_we => ram1We, 
			ram1_en => ram1En,
			ram2_oe => ram2Oe,
			ram2_we => ram2We, 
			ram2_en => ram2En,
			ram1_addr => ram1Addr, 
			ram2_addr => ram2Addr, --两个ram的地址总线
			ram1_data => ram1Data, 
			ram2_data => ram2Data, --两个ram的数据总线
			data_ready => dataReady,
			tbre => tbre,
			tsre => tsre,
			wrn => wrn,
			rdn => rdn,
			--调试信号
			display_im => display_im,
			display_dm => display_dm,
			--额外控制信号
			--dm_data_ready => zero_signal,
			--im_data_ready => zero_signal,
			stall_im => zero_signal,
			stall_dm => zero_signal,
			flush => zero_signal,
			--额外输出
			req_stall_im => req_stall_im,
			req_stall_dm => req_stall_dm
	);
	
	u17: MEMWBRegister
	port map(
		clk => clk_hand,
			rst =>rst,
			FlushSignal => MEMWB_Flush, --when this is 1, at next rising edge, flush the control signals
			KeepSignal => MEMWB_Keep,
			WB_Mux_In =>WB_Mux_out1,
			WB_CWB_In => WB_CWB_Out1,
			--
			WB_Mux_Out => WB_Mux_Out2,
			WB_CWB_Out => WB_CWB_Out2,
			--input
			PC_In => MEM_PC_Out, --this is the PC associated with this command
			Command_In => MEM_Command_Out, --the original command
			DM_In => dmOut, --the DM result
			ALU_In => MEM_ALU_Out, --ALU result
			ID_MuxC_In => MEM_MuxC_Out, --the result of ID_MuxC, writeback register
			--output
			WB_PC_Out => WB_PC_Out, --this is the PC associated with this command
			WB_Command_Out => WB_Command_Out, --the original command
			DM_Out => DM_Out,
			WB_ALU_Out => WB_ALU_Out,
			WB_MuxC_Out => WB_MuxC_Out --the result of ID_MuxC, writeback register
	);
	
	u18 : WBMUX
	port map(
			DM_in => DM_Out,
			ADM_in => WB_ALU_Out,
			WBMUX_out => WBMUX_out,
			--control signal
			control => WB_Mux_Out2
	);
	
	u19 : Control
	port map(
			CommandIn => IM_Command_Out,
			rst => rst,
			--Signal for ID
			ID_MuxAOut => ID_MuxAOut,
			ID_MuxBOut => ID_MuxBOut,
			ID_MuxCOut => ID_MuxCOut,
			ID_IMMEOut => ID_IMMEOut,
			--Signal for EX
			EX_MuxAOut => EX_MuxAOut,
			EX_MuxBOut => EX_MuxBOut,
			EX_ALUOut => EX_ALUOut,
			--Signal for MEM
			ME_DMOut => ME_DMOut,
			--Signal for WB
			WB_MuxOut => WB_MuxOut,
			WB_CWB => WB_CWB
	);
	
	u20 : HazardDetection
	port map(
			rst => rst,
			clk => clk_hand,
			IFID_CommandIn => IM_Command_Out,
			IDEX_CommandIn => EX_Command_Out, --Command stored at IDEX register
			EXMEM_CommandIn => MEM_Command_Out, --Command stored at EXMEM register
			MEMWB_CommandIn => WB_Command_Out, --Command stored at MEMWB register
			IM_Stop => req_stall_im, --when this is 1, IM needs one more step to fetch instruction
			DM_Stop => req_stall_dm, --when this is 1, DM needs one more step to fetch data
			Branch_Judge => branch_Judge,
			---------temporary solution: implement the alu and forward unit 
			OA_in => OA_Out,
			IdExReg_A => ID_MuxA_Out,
			ExMemRd => MEM_MuxC_Out,
			MemWbRd => WB_MuxC_Out,
			ALU_MEM_in => MEM_ALU_Out,
			ALU_WBMUX_in => WBMUX_out,
			---------
			---------
			PC_Out => PC_Out, --when this is 1, keep PC at next round
			PCMUX_Out => PCMUX_Out,
			IFID_Keep => IFID_Keep,
			IDEX_Keep => IDEX_Keep,
			IDEX_Flush => IDEX_Flush,
			EXMEM_Keep => EXMEM_Keep,
			EXMEM_Flush => EXMEM_Flush,
			MEMWB_Keep => MEMWB_Keep,
			MEMWB_Flush => MEMWB_Flush,
			im_state => im_state,
			im_keep => im_keep
	);
	
	u21 : Forward_Unit
	port map(
			ExMemRd => MEM_MuxC_Out,
			MemWbRd => WB_MuxC_Out,
			
			IdExReg_A => ID_MuxA_Out,
			IdExReg_B => ID_MuxB_Out,
			
			Forward_A => Forward_A,
			Forward_B => Forward_B,
			
			EX_MuxA_Out => EX_MuxA_Out,
			EX_MuxB_Out => EX_MuxB_Out,
			
			clk => clk_hand,
			rst => rst
	);
	
	u22 : CLK_Unit
	port map(
			rst => rst,
			clk_in => clk_hand,
			clk_out => clk_out
	);
	
	process(clk_hand, rst)
	begin
		--led <= r0Out;
		if (rst = '0') then
		led <= r;
		show_state := 0;
		elsif(rising_edge(clk_hand)) then
			--temp_state := CONV_INTEGER(r(15 downto 8));
			--if(PCOut(7 downto 0) = r(7 downto 0)) and (show_state = CONV_INTEGER(r(15 downto 8))) then
			if(PCOut = r) and (show_state = 0) then
			--led(15 downto 13) <= imOut(15 downto 13);
			--led(12 downto 10) <= im_Command_out(15 downto 13);
			--led(9 downto 7) <= ex_Command_out(15 downto 13);
			--led(6 downto 4) <= mem_Command_out(15 downto 13);
			--led(3 downto 1) <= wb_Command_out(15 downto 13);
			--led(0) <= WB_CWB_Out2;
			--led(15 downto 8) <= im_Command_out(15 downto 8);
			--led(7 downto 0) <= IM_PC_Out(7 downto 0);
			led <= R6Out;
			show_state := 100;
			elsif(PCOut = "00000000" & r(7 downto 0)) and (show_state /= 100) then
				show_state := show_state + 1;
			end if;
		end if;
		
	end process;
	
	--jing <= PCOut;
--	process(MEM_OB_Out,MEM_ALU_Out,req_stall_im, req_stall_dm, ME_DM_Out1)
--	begin
--		--led(15 downto 8) <= r1OUT(7 downto 0);
--		--led(7 downto 0 ) <= dmOut(7 downto 0);
--		led(15 downto 13) <= ME_DM_Out1;
--		led(12 downto 0) <= MEM_OB_Out(15 downto 3);
----		led (15 downto 8) <= im_command_out(15 downto 8);
----		led (7) <= IFID_Keep;
----		led (6 downto 5) <=MEM_OB_Out(6 downto 5);	
----		led (4 downto 0) <= im_state(4 downto 0);
--		--led<= r1out;
--	end process;
--	process(IFID_Keep,IDEX_Keep,EXMEM_Keep,EXMEM_Flush,MEMWB_Keep,MEMWB_Flush,im_keep,req_stall_im,req_stall_dm,imOut,dmOut,R1OUT)
--	begin
--		led(15)<=IFID_Keep;
--		led(14)<=IDEX_Keep;
--		led(13)<=IDEX_Flush;
--		led(12)<=EXMEM_Keep;
--		led(11)<=EXMEM_Flush;
--		led(10)<=MEMWB_Keep;
--		led(9)<=MEMWB_Flush;
--		led(8)<=im_keep;
--		led(7)<=req_stall_im; --when this is 1, IM needs one more step to fetch instruction
--		led(6)<=req_stall_dm;
--		led(5 downto 4) <= dmOut(1 downto 0);
--		led(3 downto 0) <= im_state(3 downto 0);
--		--led(15 downto 13) <= ME_DM_Out1;-- 001 读 010 写
--		--led(12 downto 0)<= MEM_ALU_Out(12 downto 0);
--		--led <= display_im;
--		
--	end process;
	process(PCOut, rst, r)
	begin
		if (r /= "0000000000000000") then
		case PCOut(7 downto 4) is
			when "0000" => digit1 <= "0111111";--0
			when "0001" => digit1 <= "0000110";--1
			when "0010" => digit1 <= "1011011";--2
			when "0011" => digit1 <= "1001111";--3
			when "0100" => digit1 <= "1100110";--4
			when "0101" => digit1 <= "1101101";--5
			when "0110" => digit1 <= "1111101";--6
			when "0111" => digit1 <= "0000111";--7
			when "1000" => digit1 <= "1111111";--8
			when "1001" => digit1 <= "1101111";--9
			when "1010" => digit1 <= "1110111";--A
			when "1011" => digit1 <= "1111100";--B
			when "1100" => digit1 <= "0111001";--C
			when "1101" => digit1 <= "1011110";--D
			when "1110" => digit1 <= "1111001";--E
			when "1111" => digit1 <= "1110001";--F
			when others => digit1 <= "0000000";
		end case;
		
		case PCOut(3 downto 0) is
			when "0000" => digit2 <= "0111111";--0
			when "0001" => digit2 <= "0000110";--1
			when "0010" => digit2 <= "1011011";--2
			when "0011" => digit2 <= "1001111";--3
			when "0100" => digit2 <= "1100110";--4
			when "0101" => digit2 <= "1101101";--5
			when "0110" => digit2 <= "1111101";--6
			when "0111" => digit2 <= "0000111";--7
			when "1000" => digit2 <= "1111111";--8
			when "1001" => digit2 <= "1101111";--9
			when "1010" => digit2 <= "1110111";--A
			when "1011" => digit2 <= "1111100";--B
			when "1100" => digit2 <= "0111001";--C
			when "1101" => digit2 <= "1011110";--D
			when "1110" => digit2 <= "1111001";--E
			when "1111" => digit2 <= "1110001";--F
			when others => digit2 <= "0000000";
		end case;
		end if;
	end process;
	--ram1Addr <= (others => '0');
end Behavioral;

