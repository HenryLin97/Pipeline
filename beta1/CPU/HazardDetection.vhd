library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--hazard detection unit should be responsible for jump instructions!
--hazard detection should set control signal for IF_MUX!
entity HazardDetection is
	Port( IFID_CommandIn : in std_logic_vector(15 downto 0); --Command stored at IFID register
			IDEX_CommandIn : in std_logic_vector(15 downto 0); --Command stored at IDEX register
			EXMEM_CommandIn : in std_logic_vector(15 downto 0); --Command stored at EXMEM register
			MEMWB_CommandIn : in std_logic_vector(15 downto 0); --Command stored at MEMWB register
			IM_Stop : in std_logic; --when this is 1, IM needs one more step to fetch instruction
			DM_Stop : in std_logic; --when this is 1, DM needs one more step to fetch data
			Branch_Judge : in std_logic; --this is not good since it comes at falling edge!
			---------temporary solution: implement the alu and forward unit 
			OA_in : in std_logic_vector(15 downto 0);
			IdExReg_A : in std_logic_vector(3 downto 0);
			ExMemRd : in std_logic_vector(3 downto 0);
			MemWbRd : in std_logic_vector(3 downto 0);
			ALU_MEM_in : in std_logic_vector(15 downto 0);
			ALU_WBMUX_in : in std_logic_vector(15 downto 0);
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
			im_keep : out std_logic;
			im_state : out std_logic_vector(4 downto 0);
			clk : in std_logic;
			rst : in std_logic
			);
end HazardDetection;

architecture Behavioral of HazardDetection is
signal need_ID_bubble : std_logic_vector(1 downto 0) := "00";
signal need_ID_bubble_back : std_logic_vector(1 downto 0) := "11";
signal skip_MEM_bubble : std_logic := '0';
signal skip_MEM_bubble_back : std_logic := '0';
signal need_ID_bubble2 : std_logic_vector(1 downto 0) := "00";
signal need_ID_bubble_back2 : std_logic_vector(1 downto 0) := "00";
begin
	process(clk, rst)
	begin
		if (rst = '0') then
			need_ID_bubble_back <= "00";
			skip_MEM_bubble_back <= '0';
			need_ID_bubble_back2 <= "00";
			--im_state <= (others => '0');
		elsif (rising_edge(clk)) then
			need_ID_bubble_back <= need_ID_bubble;
			skip_MEM_bubble_back <= skip_MEM_bubble;
			need_ID_bubble_back2 <= need_ID_bubble2;
		end if;
	end process;
	
	--process(IFID_CommandIn, IDEX_CommandIn, EXMEM_CommandIn, MEMWB_CommandIn, IM_Stop, DM_Stop, rst, skip_MEM_bubble_back, need_ID_bubble_back)
	process(rst, clk)
	begin
	if (rst = '0') then
		PC_Out <= '0'; --open PC
		PCMUX_Out <= "001";
		IFID_Keep <= '0'; --keep IFID at next rising_edge 
		IDEX_Keep <= '0';
		IDEX_Flush <= '0'; --insert a bubble between IFID and IDEX
		EXMEM_Keep <= '0';
		EXMEM_Flush <= '0';
		MEMWB_Keep <= '0';
		MEMWB_Flush <= '0';
		im_keep <= '0';
		im_state <= "00000";
	elsif(clk'event and clk='0') then
	------
	if (need_ID_bubble_back = "11") then
		PC_Out <= '0'; --open PC
		PCMUX_Out <= "001";
		IFID_Keep <= '1'; --keep IFID at next rising_edge 
		IDEX_Keep <= '0';
		IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
		EXMEM_Keep <= '0';
		EXMEM_Flush <= '0';
		MEMWB_Keep <= '0';
		MEMWB_Flush <= '0';
		need_ID_bubble <= "00";
		im_keep <= '0';
		im_state <= "00001";
	elsif (need_ID_bubble_back2 = "10") then
		PC_Out <= '1'; --keep PC
		PCMUX_Out <= "001";
		IFID_Keep <= '1'; --keep IFID at next rising_edge 
		IDEX_Keep <= '0';
		IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
		EXMEM_Keep <= '0';
		EXMEM_Flush <= '0';
		MEMWB_Keep <= '0';
		MEMWB_Flush <= '0';
		need_ID_bubble2 <= "01";
		need_ID_bubble <= "00";
		im_keep <= '1';
		im_state <= "10001";
	elsif (need_ID_bubble_back2 = "01") then
		PC_Out <= '1'; --keep PC
		PCMUX_Out <= "001";
		IFID_Keep <= '1'; --keep IFID at next rising_edge 
		IDEX_Keep <= '0';
		IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
		EXMEM_Keep <= '0';
		EXMEM_Flush <= '0';
		MEMWB_Keep <= '0';
		MEMWB_Flush <= '0';
		need_ID_bubble2 <= "00";
		im_keep <= '1';
		need_ID_bubble <= "00";
		im_state <= "10000";
	else
		if (DM_Stop = '1') then
			PC_Out <= '1'; --keep PC
			PCMUX_Out <= "001";
			IFID_Keep <= '1'; --keep IFID
			IDEX_Keep <= '1';
			IDEX_Flush <= '0';
			EXMEM_Keep <= '1';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '1';
			MEMWB_Flush <= '0';
			im_keep <= '1';
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
			im_state <= "00010";
		elsif ((EXMEM_CommandIn(15 downto 11) = "10011") or (EXMEM_CommandIn(15 downto 11) = "10010")) and (skip_MEM_bubble_back = '0') then
		--read DM, at least stop one round
			PC_Out <= '1'; --keep PC
			PCMUX_Out <= "001";
			IFID_Keep <= '1'; --open IFID in order to read at next rising_edge
			IDEX_Keep <= '1';
			IDEX_Flush <= '0';
			EXMEM_Keep <= '1';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '1';
			MEMWB_Flush <= '0';
			skip_MEM_bubble <= '1';
			im_keep <= '1';
			im_state <= "00011";
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
		elsif (IM_Stop = '1') then
			PC_Out <= '1'; --keep PC
			PCMUX_Out <= "001";
			IFID_Keep <= '1'; --keep IFID (a wrong command is waiting to get in!)
			IDEX_Keep <= '1';
			IDEX_Flush <= '0';
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '1';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			im_keep <= '0';
			im_state <= "00100";
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
		elsif (IFID_CommandIn(15 downto 11) = "00010") then --B Command
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "010";
			IFID_Keep <= '0'; --do not keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '0'; --do not insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			need_ID_bubble <= "11";
			need_ID_bubble2 <= "00";
			skip_MEM_bubble <= '0';
			im_keep <= '0';
			im_state <= "00101";
		elsif (IFID_CommandIn(15 downto 11) = "11101") and (IFID_CommandIn(7 downto 0) = "0000000") then --JR Command
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "100";
			IFID_Keep <= '0'; --do not keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '0'; --do not insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			need_ID_bubble <= "11";
			need_ID_bubble2 <= "00";
			skip_MEM_bubble <= '0';
			im_keep <= '0';
			im_state <= "00110";
		elsif ((IDEX_CommandIn(15 downto 11) = "00100") and (IdExReg_A /= "1111") and
		(((IdExReg_A = ExMemRd) and (ALU_MEM_in = "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A = MemWbRd) and (ALU_WBMUX_in = "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A /= MemWbRd) and (OA_in = "0000000000000000")))) then --BEQZ Command
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "011";
			IFID_Keep <= '1'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			skip_MEM_bubble <= '0';
			need_ID_bubble <= "11";
			need_ID_bubble2 <= "00";
			im_keep <= '0';
			im_state <= "00111";
		--elsif ((IDEX_CommandIn(15 downto 11) = "00101")and (Branch_Judge = '1')) then --BEQZ or BENZ Command
		elsif ((IDEX_CommandIn(15 downto 11) = "00101") and (IdExReg_A /= "1111") and
		(((IdExReg_A = ExMemRd) and (ALU_MEM_in /= "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A = MemWbRd) and (ALU_WBMUX_in /= "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A /= MemWbRd) and (OA_in /= "0000000000000000")))) then --BNEZ Command
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "011";
			IFID_Keep <= '1'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			skip_MEM_bubble <= '0';
			need_ID_bubble <= "11";
			need_ID_bubble2 <= "00";
			im_keep <= '0';
			im_state <= "00111";
		--elsif (IDEX_CommandIn(15 downto 8) = "01100000") then --BETQZ Command
		elsif ((IDEX_CommandIn(15 downto 8) = "01100000") and (IdExReg_A /= "1111") and
		(((IdExReg_A = ExMemRd) and (ALU_MEM_in = "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A = MemWbRd) and (ALU_WBMUX_in = "0000000000000000")) or
		((IdExReg_A /= ExMemRd) and (IdExReg_A /= MemWbRd) and (OA_in = "0000000000000000")))) then --BEQZ Command
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "011";
			IFID_Keep <= '1'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			skip_MEM_bubble <= '0';
			need_ID_bubble <= "11";
			need_ID_bubble2 <= "00";
			im_keep <= '0';
			im_state <= "01000";
		elsif (IDEX_CommandIn(15 downto 11) = "10011") and ((IDEX_CommandIn(7 downto 5) = IFID_CommandIn(10 downto 8)) or (IDEX_CommandIn(7 downto 5) = IFID_CommandIn(7 downto 5))) then
			PC_Out <= '1'; --keep PC
			PCMUX_Out <= "001";
			IFID_Keep <= '1'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
			skip_MEM_bubble <= '0';
			im_keep <= '1';
			im_state <= "01010";
		elsif (IDEX_CommandIn(15 downto 11) = "11011") then
			PC_Out <= '1'; --keep PC
			PCMUX_Out <= "001";
			IFID_Keep <= '1'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '1'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
			skip_MEM_bubble <= '0';
			im_keep <= '1';
			im_state <= "01010";
		elsif (IFID_CommandIn(15 downto 11) = "11011") and (IDEX_CommandIn(15 downto 0) /= "0000100000000000") then
			PC_Out <= '1';
			PCMUX_Out <= "001";
			IFID_Keep <= '1';
			IDEX_Keep <= '0';
			IDEX_Flush <= '1';
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			need_ID_bubble2 <= "10";
			need_ID_bubble <= "00";
			skip_MEM_bubble <= '0';
			im_keep <= '1';
			im_state <= "01011";
		else --default case
			PC_Out <= '0'; --open PC
			PCMUX_Out <= "001";
			IFID_Keep <= '0'; --keep IFID at next rising_edge 
			IDEX_Keep <= '0';
			IDEX_Flush <= '0'; --insert a bubble between IFID and IDEX
			EXMEM_Keep <= '0';
			EXMEM_Flush <= '0';
			MEMWB_Keep <= '0';
			MEMWB_Flush <= '0';
			skip_MEM_bubble <= '0';
			im_keep <= '0';
			im_state <= "01001";
			need_ID_bubble <= "00";
			need_ID_bubble2 <= "00";
		end if;
	end if;
	end if;
	end process;
end Behavioral;