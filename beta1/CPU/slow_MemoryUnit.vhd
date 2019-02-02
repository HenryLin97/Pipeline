----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:53:37 12/03/2018 
-- Design Name: 
-- Module Name:    slow_MemoryUnit - Behavioral 
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

entity slow_MemoryUnit is
port(
			clk : in std_logic;
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
			ram1_oe, ram1_we, ram1_en : out STD_LOGIC;
			ram2_oe, ram2_we, ram2_en : out STD_LOGIC;
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
			req_stall_dm :out std_logic  -- 1��ʱ����ͣ 0��ʱ�򲻶�
);
end slow_MemoryUnit;

architecture Behavioral of slow_MemoryUnit is
	signal state : std_logic_vector(1 downto 0) := "00";	--�ô桢���ڲ�����״̬
	signal rflag : std_logic := '0';		--rflag='1'����Ѵ��������ߣ�ram1_data���ø��裬���ڽ�ʡ״̬�Ŀ���
	shared variable MemRead : std_logic := '0';							--���ƶ�DM���źţ�='1'������Ҫ��
	shared variable MemWrite: std_logic := '0';						--����дDM���źţ�='1'������Ҫд
begin
process(dmControl)
begin
	case dmControl is
		when "000"=>
			MemRead := '0';
			MemWrite:= '0';
		when "001"=>
			MemRead := '1';
			MemWrite:= '0';
		when "010"=>
			MemRead := '0';
			MemWrite:= '1';
		when others=>
			MemRead := '0';
			MemWrite:= '0';
	end case;
end process;
process(clk, rst)
	begin
	
		if (rst = '0') then
			ram2_oe <= '1';
			ram2_we <= '1';
			wrn <= '1';
			rdn <= '1';
			rflag <= '0';
			
			ram1_addr <= (others => '0'); --�ɲ�Ҫ����
			ram2_addr <= (others => '0'); --�ɲ�Ҫ����
			
			dmOut <= (others => '0');
			Memory_PCOut <= (others => '0');
			imOut <= "0000100000000000";
			
			state <= "00";			--rst֮�ա���
--			flashstate <= "001";
			--flash_finished <= '0';
			--current_addr <= (others => '0');
			
		elsif (clk'event and clk = '1') then 
--			if (flash_finished = '1') then			--��flash����kernelָ�ram2�����
--				flash_byte <= '1';
--				flash_vpen <= '1';
--				flash_rp <= '1';
--				flash_ce <= '1';	--��ֹflash
				ram1_en <= '1';
				ram1_oe <= '1';
				ram1_we <= '1';
				ram1_addr(17 downto 0) <= (others => '0');
				ram2_en <= '0';
				ram2_addr(17 downto 16) <= "00";
				ram2_oe <= '1';
				ram2_we <= '1';
				wrn <= '1';
				rdn <= '1';
				
				case state is 
					--when "00" =>
					--	state <= "01";
						
					when "00" =>		--׼����ָ��
						ram2_data <= (others => 'Z');
						--ram2_addr(15 downto 0) <= PC;
						wrn <= '1';
						rdn <= '1';
						ram2_oe <= '0';
						state <= "01";
						
					when "01" =>		--����ָ�׼����/д ����/�ڴ�
						ram2_oe <= '1';
						imOut <= ram2_data;
						Memory_PCOut <= imAddr;
						if (MemWrite = '1') then	--���Ҫд
							rflag <= '0';
							if (dmAddr = x"BF00") then 	--׼��д����
								ram1_data(7 downto 0) <= dmIn(7 downto 0);
								wrn <= '0';
							else							--׼��д�ڴ�
								ram2_addr(15 downto 0) <= dmAddr;
								ram2_data <= dmIn;
								ram2_we <= '0';
							end if;
						elsif (MemRead = '1') then	--���Ҫ��
							if (dmAddr = x"BF01") then 	--׼��������״̬
								dmOut(15 downto 2) <= (others => '0');
								dmOut(1) <= data_ready;
								dmOut(0) <= tsre and tbre;
								if (rflag = '0') then	--������״̬ʱ��ζ�Ž���������Ҫ��/д��������
									ram1_data <= (others => 'Z');	--��Ԥ�Ȱ�ram1_data��Ϊ����
									rflag <= '1';	--���������Ҫ�������ֱ�Ӱ�rdn��'0'��ʡһ��״̬��Ҫд����rflag='0'��������д���ڵ�����
								end if;	
							elsif (dmAddr = x"BF00") then	--׼������������
								rflag <= '0';
								rdn <= '0';
							else							--׼�����ڴ�
								ram2_data <= (others => 'Z');
								ram2_addr(15 downto 0) <= dmAddr;
								ram2_oe <= '0';
							end if;
						end if;	
						state <= "10";
						
					when "10" =>		--��/д ����/�ڴ�
						if(MemWrite = '1') then		--д
							if (dmAddr = x"BF00") then		--д����
								wrn <= '1';
							else							--д�ڴ�
								ram2_we <= '1';
							end if;
						elsif(MemRead = '1') then	--��
							if (dmAddr = x"BF01") then		--������״̬���Ѷ�����
								null;
							elsif (dmAddr = x"BF00") then 	--����������
								rdn <= '1';
								dmOut(15 downto 8) <= (others => '0');
								dmOut(7 downto 0) <= ram1_data(7 downto 0);
							else							--���ڴ�
								ram2_oe <= '1';
								dmOut <= ram2_data;
							end if;
						end if;
						state <= "00";
						
					when others =>
						state <= "00";
						
				end case;
				
--			else				--��flash����kernelָ�ram2��δ��ɣ����������
--				if (cnt = 1000) then
--					cnt := 0;
--					
--					case flashstate is
--						
--						
--						when "001" =>		--WE��0
--							ram2_en <= '0';
--							ram2_we <= '0';
--							ram2_oe <= '1';
--							wrn <= '1';
--							rdn <= '1';
--							flash_we <= '0';
--							flash_oe <= '1';
--							
--							flash_byte <= '1';
--							flash_vpen <= '1';
--							flash_rp <= '1';
--							flash_ce <= '0';
--							
--							flashstate <= "010";
--							
--						when "010" =>
--							flash_data <= x"00FF";
--							flashstate <= "011";
--							
--						when "011" =>
--							flash_we <= '1';
--							flashstate <= "100";
--							
--						when "100" =>
--							flash_addr <= "000000" & current_addr & '0';
--							flash_data <= (others => 'Z');
--							flash_oe <= '0';
--							flashstate <= "101";
--							
--						when "101" =>
--							flash_oe <= '1';
--							ram2_we <= '0';
--							ram2_addr <= "00" & current_addr;
--							ram2AddrOutput <= "00" & current_addr;	--����
--							ram2_data <= flash_data;
--							flashstate <= "110";
--						
--						when "110" =>
--							ram2_we <= '1';
--							current_addr <= current_addr + '1';
--							flashstate <= "001";
--						
--							
--						when others =>
--							flashstate <= "001";
--						
--					end case;
--					
--					if (current_addr > x"0249") then
--						flash_finished <= '1';
--					end if;
--				else 
--					if (cnt < 1000) then
--						cnt := cnt + 1;
--					end if;
--				end if;	--cnt 
--				
--			end if;	--flash finished or not
			
		end if;	--rst/clk_raise
		
	end process;
	
	
	--MemoryState <= state;
--	flashFinished <= flash_finished;
--	FlashStateOut <= flashstate;

end Behavioral;

