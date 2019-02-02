library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--注以下统一用 0 表示使用
--用1表示不使用
entity MemoryTest is
	Port( clk : in std_logic;
			rst : in std_logic;
			keep_im : in std_logic; --when this is 1, keep imOut!
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
			Memory_PCOut : out std_logic_vector(15 downto 0);
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
--			dm_data_ready : out std_logic;
--			im_data_ready : out std_logic;
			stall_im : in std_logic;
			stall_dm : in std_logic;
			flush : in std_logic;
			--额外输出
			req_stall_im :out std_logic;
			req_stall_dm :out std_logic
			);
end MemoryTest;

architecture Behavioral of MemoryTest is
shared variable count: INTEGER range 0 to 10 := 0;
Constant border_position : integer range 0 to 65536:=32768;--0x8000
Constant chuankou_position : integer range 0 to 65536:=48896;--0xBF00
Constant chuankou_status_position : integer range 0 to 65536:=48897; --0xBF01
shared variable position : integer range 0 to 65536:=0;
type dm_target_type is (RAM1,RAM2,CHUANKOU,CHUANKOU_STATUS);
shared variable dm_target : dm_target_type;
signal im_state : std_logic := '0'; --use to simulate memory stop
signal dm_state : std_logic := '0'; --use to simulate memory stop
signal current_data : std_logic_vector(15 downto 0):=(others => '0');
begin
	process(clk, rst)
	begin
		if(rst = '0') then
			ram1_oe <= '1';
			ram1_we <= '1';
			ram1_en <= '1';
			ram2_oe <= '1';
			ram2_we <= '1';
			ram2_en <= '1';
			wrn <= '1';
			rdn <= '1';
			req_stall_im <= '0';
			req_stall_dm <= '0';
			--dm_data_ready <= '1';
			--im_data_ready <= '1';
			imOut <= "0000100000000000";
			dmOut <= "1111111111111111";
			Memory_PCOut <= (others=>'1');
		elsif(rising_edge(clk)) then
			--imOut <= "0100000101000001"; -- instruction
			--get dm postion 
			if(dmControl = "001" )or(dmControl = "010") then
				position := CONV_INTEGER(dmAddr);
				if(position < border_position) then
					dm_target:= RAM1; --IM
				elsif(position = chuankou_position) then
					dm_target:= CHUANKOU;
				elsif(position = chuankou_status_position) then
					dm_target:= CHUANKOU_STATUS;
				else
					dm_target:= RAM2; --DM
				end if;
			else
				--什么都不做
			end if;
			Memory_PCOut <= imAddr;
			if(dmControl = "001")then	--read
				case dm_target is
					when RAM1 =>
						if (dmAddr = "0000000000000111") and (dm_state = '0') then
							dmOut <= "1010101010101010";
							dm_state <= '1';
							req_stall_dm <= '1'; --dm need to wait
						else
							dmOut <= "0010000000000001";
							--dm_state <= '0';
							req_stall_dm <= '0';
						end if;
					when RAM2 =>
						dmOut <= "0010000000000010";
					when CHUANKOU =>--BF00
						dmOut <= "0010000000000011";
					when CHUANKOU_STATUS =>
						dmOut <= "0010000000000100";
				end case;
				 --memory value
			elsif(dmControl = "010")then  --write
				case dm_target is
					when RAM1 =>
						dmOut <= "0100000000000001";
					when RAM2 =>
						dmOut <= "0100000000000010";
					when CHUANKOU =>--BF00
						dmOut <= "0100000000000011";
					when CHUANKOU_STATUS =>
						dmOut <= "0100000000000100";
				end case;
			else
			end if;
			if (keep_im = '0') then
				if (im_state = '1') then
					imOut <= "0100001000100001";
					req_stall_im <= '0';
					im_state <= '0';
				else
				case imAddr is
					when "0000000000000000"=>
						imOut <= "0110100000100000";
					when "0000000000000001"=>
						imOut <= "1101100000000000";
					when "0000000000000010"=>
						imOut <= "1101100000000001";
					when "0000000000000011"=>
						imOut <= "1101100000000010";
					when "0000000000000100"=>
						imOut <= "1101100000000011";
					when "0000000000000101"=>
						imOut <= "1101100000000100";
					when "0000000000000110"=>
						imOut <= "1101100000000101";
					when "0000000000000111"=>
						imOut <= "1101100000000110";
					when "0000000000001000"=>
						imOut <= "0100100100000001";
					when "0000000000001001"=>
						imOut <= "1101100000100111";
					when "0000000000001010"=>
						imOut <= "0100100100000001";
					when "0000000000001001"=>
						imOut <= "1101100000101000";
					when others=>
						imOut <= "0000100000000000";
						--imOut <= "0100000101000001";--addiu
--					when "0000000000000001"=>
--						if (im_state = '0') then
--							imOut <= "0100100100100000"; --add 32, should not implement
--							req_stall_im <= '1';
--							im_state <= '1';
--						else
--							imOut <= "0100001000100001";
--						end if;
--					when "0000000000000010"=>
--						imOut <= "1001100010000001"; --LW MEM[r0 + 1] -> r4
--					when "0000000000000011"=>
--						imOut <= "1101100000100001";
--					when "0000000000000100"=>
--						--imOut <= "0010100111111011"; --BNEZ
--						--imOut <= "0010000011111011"; --BEQZ
--						imOut <= "0001011111111011"; --B
--						--imOut <= "1110100000000000";
--						--imOut <= "0000100000000000";
--					when "0000000000000101"=>
--						imOut <= "0000100000000000"; --nop
--					when "0000000000000110"=>
--						imOut <= "0100100100100000"; --add 32, should not implement
--					when "0000000000000111"=>
--						imOut <= "0100100100100000"; --add 32, should not implement
--					when others=>
--						imOut <= "0000100000000000";
				end case;
				end if;
			end if;
			
		end if;
	end process;

end Behavioral;

