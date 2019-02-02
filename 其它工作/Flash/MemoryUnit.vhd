----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:55:38 11/11/2018 
-- Design Name: 
-- Module Name:    MemoryUnit - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--ע����ͳһ�� 0 ��ʾʹ��
--��1��ʾ��ʹ��
entity MemoryUnit is
	Port( clk : in std_logic;
			rst : in std_logic;
			keep_im : in std_logic; --when this is 1, keep imOut!
			--DM
			dmControl : in std_logic_vector(2 downto 0);-- 001 �� 010 д 000 ����
			dmAddr : in std_logic_vector(15 downto 0); --����ram�õĵ�ַ��ע����������õ������ַ
			dmIn : in std_logic_vector(15 downto 0);		--д�ڴ�ʱ��Ҫд��ram1������
			dmOut : out std_logic_vector(15 downto 0);	--��DMʱ��������������/�����Ĵ���״̬
			--IM
			imAddr : in std_logic_vector(15 downto 0);
			imOut:	out std_logic_vector(15 downto 0);
			Memory_PCOut : out std_logic_vector(15 downto 0);--PC��ַ
			--�����ź� ��ʹ�����޹�
			ram1_oe, ram1_we, ram1_en : out STD_LOGIC:='1';
			ram2_oe, ram2_we, ram2_en : out STD_LOGIC:='1';
			ram1_addr, ram2_addr : out STD_LOGIC_VECTOR(17 downto 0); --����ram�ĵ�ַ����
			ram1_data, ram2_data : inout STD_LOGIC_VECTOR(15 downto 0); --����ram����������
			data_ready : in std_logic;
			tbre : in std_logic;
			tsre : in std_logic;
			wrn : out std_logic;
			rdn : out std_logic;
			--�����ź� ���ֻ�����������ǰ��ȡֵ���ź�
			display_im : out std_logic_vector(15 downto 0);
			display_dm : out std_logic_vector(15 downto 0);
			--��������ź�
			stall_im : in std_logic;
			stall_dm : in std_logic;
			flush : in std_logic;
			--�������
			req_stall_im :out std_logic; -- 1��ʱ����ͣ 0��ʱ�򲻶�
			req_stall_dm :out std_logic;  -- 1��ʱ����ͣ 0��ʱ�򲻶�
			
			--flash
			flashFinished : out std_logic := '0';
		
			--Flash
			flash_addr : out std_logic_vector(22 downto 0);		--flash��ַ��
			flash_data : inout std_logic_vector(15 downto 0);	--flash������
		
			flash_byte : out std_logic := '1';	--flash����ģʽ������'1'
			flash_vpen : out std_logic := '1';	--flashд����������'1'
			flash_rp : out std_logic := '1';		--'1'��ʾflash����������'1'
			flash_ce : out std_logic := '0';		--flashʹ��
			flash_oe : out std_logic := '1';		--flash��ʹ�ܣ�'0'��Ч��ÿ�ζ���������'1'
			flash_we : out std_logic := '1'		--flashдʹ��
			);
end MemoryUnit;

architecture Behavioral of MemoryUnit is
	--NOP
	shared variable nop :STD_LOGIC_VECTOR(15 downto 0):= "0000100000000000";
	--DM use RAM1 IM use RAM2
	type ram1_state_type is (RAM1_IDLE,RAM1_BUSY,RAM1_STALL);
	shared variable ram1_state  : ram1_state_type;
	type ram2_state_type is (RAM2_IDLE,RAM2_BUSY,RAM2_STALL);--IM
	shared variable ram2_state  : ram2_state_type;
	shared variable temp_addr : STD_LOGIC_VECTOR(15 downto 0); 
	shared variable temp_data : STD_LOGIC_VECTOR(15 downto 0);
	Constant border_position : integer range 0 to 65536:=32768;--0x8000
	Constant chuankou_position : integer range 0 to 65536:=48896;--0xBF00
	Constant chuankou_status_position : integer range 0 to 65536:=48897; --0xBF01
	shared variable position : integer range 0 to 65536:=0;
	type dm_target_type is (RAM1,RAM2,CHUANKOU,CHUANKOU_STATUS);
	shared variable dm_target : dm_target_type;
	
	
	--for test
	signal state_test : std_logic_vector(15 downto 0);
	shared variable dmControl_state : STD_LOGIC_VECTOR(2 downto 0);
	shared variable keep_im_state : std_logic;
	--flash
	signal flash_finished : std_logic := '0';
	--type FLASH_STATE is (STATE1, STATE2, STATE3, STATE4, STATE5, STATE6);
	--signal flashstate : FLASH_STATE := STATE1;	--��flash����ָ�ram2��״̬
	signal flashstate : std_logic_vector(2 downto 0) := "001";
	shared variable current_addr : std_logic_vector(15 downto 0) := (others => '0');	--flash��ǰҪ���ĵ�ַ
	shared variable cnt : integer := 0;	--��������50Mʱ��Ƶ����1M
begin
	process(clk, rst)
	begin
		if(rst = '0') then
			keep_im_state := '0';
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
			ram1_state := RAM1_IDLE;
			ram2_state := RAM2_IDLE;
			ram1_addr <= (others =>'0');
			ram2_addr <= (others =>'0');
			ram2_data <= "0000100000000000";
			ram1_data <= "ZZZZZZZZZZZZZZZZ";
			Memory_PCOut <= (others=>'1');
			state_test <= "0000000000000000";
			--flash
			flashstate <= "001";
			current_addr := (others => '0');
			display_im<= x"0000";
		elsif(rising_edge(clk)) then
			if (flash_finished = '1') then			--��flash����kernelָ�ram2�����
				--�ر�flash
				flash_byte <= '1';
				flash_vpen <= '1';
				flash_rp <= '1';
				flash_ce <= '1';	
				
			--get dm postion 
			--if(dmControl = "001" )or(dmControl = "010") then
				position := CONV_INTEGER(dmAddr);
				if(position < border_position) then
					dm_target:= RAM2; --IM
				elsif(position = chuankou_position) then
					dm_target:= CHUANKOU;
				elsif(position = chuankou_status_position) then
					dm_target:= CHUANKOU_STATUS;
				else
					dm_target:= RAM1; --DM
					
				end if;
			dmControl_state := dmcontrol;
			keep_im_state := keep_im;
			--else
			--end if;
			Memory_PCOut <= imAddr;
			req_stall_im <= '0';
			req_stall_dm <= '0';
			--------------------------------------
			if(dmControl = "001") then
				
				--��DM��IM
				case(dm_target) is
					when RAM1 => --������д
						state_test <= "0000000000001001";
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&imAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM2_BUSY =>
								req_stall_im <= '1';
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--��DM
							when RAM1_IDLE =>
								ram1_en <= '0';
								ram1_we <= '1';
								ram1_oe <= '0';
								ram1_addr <= "00"&dmAddr;
								ram1_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM1_BUSY =>
								req_stall_dm <= '1';--��Ҫ���ԣ�һ�������Ƿ����д��
							when RAM1_STALL =>
						end case;
					
					when RAM2 =>	--��ʱ��IM��DMͬ��RAM2���ͻ
						state_test <= "0000000000001010";
						--req_stall_im <= '1';--��ͣIM
						case(ram2_state) is
							when RAM2_IDLE =>--��DM
								ram1_en <= '1';
								ram1_we <= '1';
								ram1_oe <= '1';
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&dmAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
								--dmOut<=ram2_data;
							when RAM2_BUSY =>
								req_stall_dm <= '1';
							when RAM2_STALL =>
						end case;
					
					
					--������״̬
					when CHUANKOU_STATUS =>
						state_test <= "0000000000001011";
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&imAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--������״̬
							when RAM1_IDLE =>
								ram1_en <= '1';
								ram1_we <= '1';
								ram1_oe <= '1';
--								dmOut(15 downto 2) <= (others => '0');
--								dmOut(1) <= data_ready;
--								dmOut(0) <= tsre and tbre;
								ram1_data <= (others => 'Z');	--��Ԥ�Ȱ�ram1_data��Ϊ����
							when RAM1_BUSY =>
							when RAM1_STALL =>
						end case;					
					
					--����������
					when CHUANKOU =>
						state_test <= "0000000000001100";
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&imAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--����������
							when RAM1_IDLE =>
								ram1_en <= '1';
								ram1_we <= '1';
								ram1_oe <= '1';
								rdn <= '0';
								ram1_state := RAM1_BUSY;
								req_stall_dm <= '1';
							when RAM1_BUSY =>
								rdn <= '1';
								ram1_state := RAM1_IDLE;
							when RAM1_STALL =>
						end case;

						
				end case;					
			elsif(dmControl = "010") then
				case(dm_target) is
					
					when RAM1 => --������д
						state_test <= "0000000000010001";
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&imAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--дDM
							when RAM1_IDLE =>
								ram1_en <= '0';
								ram1_we <= '0';
								ram1_oe <= '1';
								ram1_addr <= "00"&dmAddr;
								ram1_data<= dmIn;
							when RAM1_BUSY =>
							when RAM1_STALL =>
						end case;
						
					when RAM2 => --��ʱ��IM��DMͬ��RAM2���ͻ
						state_test <= "0000000000010010";
						--req_stall_im <= '1';--��ͣIM
						case(ram2_state) is
							when RAM2_IDLE =>--дDM
								ram2_en <= '0';
								ram2_we <= '0';
								ram2_oe <= '1';
								ram1_en <= '1';
								ram1_we <= '1';
								ram1_oe <= '1';
								ram2_addr <= "00"&dmAddr;
								ram2_data<= dmIn;
							when RAM2_BUSY =>
								req_stall_dm <= '1';
							when RAM2_STALL =>
						end case;
						
					when CHUANKOU => --IM����CHUANKOUд ����ͻ
						state_test <= "0000000000010011";
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '0';
								ram2_addr <= "00"&imAddr;
								ram2_data <= "ZZZZZZZZZZZZZZZZ";
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--д��������
							when RAM1_IDLE =>
								ram1_en <= '1';
								ram1_we <= '1';
								ram1_oe <= '1';
								ram1_data(15 downto 8) <= (others => '0');
								ram1_data(7 downto 0) <= dmIn(7 downto 0);
								wrn <= '0';
								ram1_state := RAM1_BUSY;
								req_stall_dm <= '1';
							when RAM1_BUSY =>
								wrn <= '1';
								ram1_state := RAM1_IDLE;
							when RAM1_STALL =>
								
						end case;
					when CHUANKOU_STATUS =>
						state_test <= "0000000000010100";
						--Ӧ�ò��ᷢ�͵�
				end case;
			else --000
				ram1_en <= '1';
				ram1_we <= '1';
				ram1_oe <= '1';
				state_test <= "0000000000100000";
				case(ram2_state) is
					when RAM2_IDLE =>--��IM
						ram2_en <= '0';
						ram2_we <= '1';
						ram2_oe <= '0';
						ram2_addr <= "00"&imAddr;
						ram2_data <= "ZZZZZZZZZZZZZZZZ";
						--test
						--display_im <= "0000000000000001";
					when RAM2_BUSY =>
						--req_stall_im <= '1';
					when RAM2_STALL =>
				end case;
			end if;
			
--			--this part read flash read
			else --flash read
				if (cnt = 5000) then
					cnt := 0;
					if (current_addr < x"0218") then
					case flashstate is
						
						
						when "001" =>		--WE��0
							ram2_en <= '0';
							ram2_we <= '0';
							ram2_oe <= '1';
							wrn <= '1';
							rdn <= '1';
							flash_we <= '0';
							flash_oe <= '1';
							
							flash_byte <= '1';
							flash_vpen <= '1';
							flash_rp <= '1';
							flash_ce <= '0';
							
							flashstate <= "010";
							
						when "010" =>
							flash_data <= x"00FF";
							flashstate <= "011";
							
						when "011" =>
							flash_we <= '1';
							flashstate <= "100";
							
						when "100" =>
							flash_addr <= "000000" & current_addr & '0';
							flash_data <= (others => 'Z');
							flash_oe <= '0';
							flashstate <= "101";
							
						when "101" =>
							
							ram2_we <= '0';
							ram2_addr <= "00" & current_addr;
							--ram2AddrOutput <= "00" & current_addr;	--����
							ram2_data <= flash_data;
							display_im <= flash_data;
							flash_oe <= '1';
							flashstate <= "110";
						
						when "110" =>
							flash_oe <= '1';
							flash_we <= '1';
							flash_data <= (others => 'Z');
							ram2_we <= '1';
							current_addr := current_addr + '1';
							flashstate <= "001";
						
							
						when others =>
							flashstate <= "001";
						
					end case;
					end if;
					if (current_addr > x"0217") then
						flash_finished <= '0';--�ĳ�1
						display_im <= x"FFFF";
					end if;
				else 
					if (cnt < 5000) then
						cnt := cnt + 1;
					end if;
				end if;	--cnt 
				flashFinished <= flash_finished;
			end if;--flash
		end if;--rst clk
	end process;
	
--	process(ram1_data)
--	begin
--		ImOut <= ram1_data;
--		dmOut <="0000000000000001";
--		display_im <= "0000000000000000";
--		display_dm <= "0000000000000000";
--	end process;
--	process(dmControl,dmAddr,dmIn)
--	begin
--		display_im(15 downto 13)<=dmControl;
--		display_im(12 downto 0)<= dmAddr(12 downto 0);
--		--display_im(5 downto 0)<= dmIn(5 downto 0);
--	end process;
	
	process(rst,clk)
	begin
		
		if(rst = '0') then
			dmOut <= "0000100000000000";
			ImOut <= "0000100000000000";
			--req_stall_im <= '0';
			--req_stall_dm <= '0';
			--display_im <= "0000000000000000";
			--display_dm <= "0000000000000000";
		elsif(falling_edge(clk)) then
			if(flash_finished = '1') then--flash
			if(dmControl_state = "001") then --read
				case(dm_target) is
					
					when RAM1 => --������д
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								if(keep_im_state = '0') then
									imOut <= ram2_data; --output IM
								end if;
							when RAM2_BUSY =>
								--req_stall_im <= '1';
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--��DM
							when RAM1_IDLE =>
								dmOut <= ram1_data; 
							when RAM1_BUSY =>
								--req_stall_dm <= '1';
							when RAM1_STALL =>	
						end case;
					
					when RAM2 => --ֻ��dm
						--req_stall_im<='0';
						case(ram2_state) is
							when RAM2_IDLE =>--��DM
								 --imOut <= nop;
								dmOut <= ram2_data;
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
					
					when CHUANKOU_STATUS => --������״̬
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								if(keep_im_state = '0') then
									imOut <= ram2_data; --output IM
								end if;
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--������״̬
							when RAM1_IDLE =>
								dmOut(15 downto 2) <= (others => '0');
								dmOut(1) <= data_ready;
								dmOut(0) <= tsre and tbre;
							when RAM1_BUSY =>
							when RAM1_STALL =>
						end case;
						
					when CHUANKOU =>--����������
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								if(keep_im_state = '0') then
									imOut <= ram2_data; --output IM
								end if;
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--����������
							when RAM1_IDLE =>
								--req_stall_dm <= '1';
							when RAM1_BUSY =>
								dmOut(15 downto 8) <= (others => '0');
								dmOut(7 downto 0) <= ram1_data(7 downto 0);
								--req_stall_dm <='0';
							when RAM1_STALL =>
						end case;

				end case;
			elsif(dmControl_state = "010") then--write
				case(dm_target) is
					
					when RAM1 => --������д
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								if(keep_im_state = '0') then
									imOut <= ram2_data; --output IM
								end if;
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--дDM
							when RAM1_IDLE =>
							when RAM1_BUSY =>
							when RAM1_STALL =>
						end case;
					
					when RAM2 => --��ʱ��IM��DMͬ��RAM2���ͻ
						--req_stall_im <= '1';
						case(ram2_state) is
							when RAM2_IDLE =>--дDM
								--if(keep_im_state = '0') then
									--imOut <= nop;
								--end if;
							when RAM2_BUSY =>
								--req_stall_dm <='1';
							when RAM2_STALL =>
							
						end case;
					
					when CHUANKOU => --��IM д����
						case(ram2_state) is
							when RAM2_IDLE =>--��IM
								if(keep_im_state = '0') then
									imOut <= ram2_data; --output IM
								end if;
							when RAM2_BUSY =>
							when RAM2_STALL =>
						end case;
						case(ram1_state) is--д����
							when RAM1_IDLE =>
								--req_stall_dm <= '1';
							when RAM1_BUSY =>
								--req_stall_dm <= '0';
							when RAM1_STALL =>
						end case; 
						
					when CHUANKOU_STATUS =>--�������λ��д

				end case;
			else --000
				case(ram2_state) is
					when RAM2_IDLE =>--��IM
						if(keep_im_state = '0') then
							imOut <= ram2_data; --output IM
						end if;
						--display_im <= "0000000000000001";
					when RAM2_BUSY =>
					when RAM2_STALL =>
				end case;
			end if;
			end if; --flash
		end if;--clk and rst
	end process;
end Behavioral;

