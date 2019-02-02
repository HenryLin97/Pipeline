library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity VGA_Controller is
	port (
		reset	: in  std_logic;
		CLK_in	: in  std_logic;			--50Mʱ������
		
		ramaddr	: out std_logic_vector	(15 downto 0);	--0~2915
		ramdata	: in std_logic_vector	(1 downto 0);	--0��1��2��3��
		
		vgaStart : in std_logic;
		vgaFinish: out std_logic:='1';

	--VGA Side
		hs,vs	: out std_logic;		--��ͬ������ͬ���ź�
		oRed	: out std_logic_vector (2 downto 0);
		oGreen	: out std_logic_vector (2 downto 0);
		oBlue	: out std_logic_vector (2 downto 0)
	);		
end entity VGA_Controller;

architecture behave of VGA_Controller is

--VGA
	signal CLK,CLK_2	: std_logic;
	signal rt,gt,bt	: std_logic_vector (2 downto 0);
	signal hst,vst	: std_logic;
	signal x		: std_logic_vector (9 downto 0);		--X����
	signal y		: std_logic_vector (8 downto 0);		--Y����
	signal addr_start	: std_logic_vector (15 downto 0):="1000000000000000";	--��ʼ��ַ
	
begin
CLK<=CLK_2;
 -----------------------------------------------------------------------
	process (CLK_in)
	begin
		if CLK_in'event and CLK_in = '1' then	--��50M�����źŶ���Ƶ
			CLK_2 <= not CLK_2;
		end if;
	end process;
		

 -----------------------------------------------------------------------
	process (CLK, reset)	--������������������������
	begin
		if reset = '0' then
			x <= (others => '0');
		elsif CLK'event and CLK = '1' then
			if x = 799 then
				x <= (others => '0');
			else
				x <= x + 1;
			end if;
		end if;
	end process;

  -----------------------------------------------------------------------
	 process (CLK, reset)	--����������������������
	 begin
	  	if reset = '0' then
	   		y <= (others => '0');
	  	elsif CLK'event and CLK = '1' then
	   		if x = 799 then
	    		if y = 524 then
	     			y <= (others => '0');
	    		else
	     			y <= y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
 
  -----------------------------------------------------------------------
	 process (CLK, reset)	--��ͬ���źŲ�����ͬ�����96��ǰ��16��
	 begin
		  if reset = '0' then
		   hst <= '1';
		  elsif CLK'event and CLK = '1' then
		   	if x >= 656 and x < 752 then
		    	hst <= '0';
		   	else
		    	hst <= '1';
		   	end if;
		  end if;
	 end process;
 
 -----------------------------------------------------------------------
	 process (CLK, reset)	--��ͬ���źŲ�����ͬ�����2��ǰ��10��
	 begin
	  	if reset = '0' then
	   		vst <= '1';
	  	elsif CLK'event and CLK = '1' then
	   		if y >= 490 and y< 492 then
	    		vst <= '0';
	   		else
	    		vst <= '1';
	   		end if;
	  	end if;
	 end process;
 -----------------------------------------------------------------------
	 process (CLK, reset)	--��ͬ���ź����
	 begin
	  	if reset = '0' then
	   		hs <= '0';
	  	elsif CLK'event and CLK = '1' then
	   		hs <=  hst;
	  	end if;
	 end process;

 -----------------------------------------------------------------------
	 process (CLK, reset)	--��ͬ���ź����
	 begin
	  	if reset = '0' then
	   		vs <= '0';
	  	elsif CLK'event and CLK='1' then
	   		vs <=  vst;
	  	end if;
	 end process;

-----------------------------------------------------------------------
	process(reset,clk,x,y) -- XY���궨λ����
	begin  
		if reset='0' then
	      rt <= "000";
			gt	<= "000";
			bt	<= "000";	
		elsif(clk'event and clk='1' and vgaStart='1')then 
			rt <= "000";
			gt	<= "000";
			bt	<= "000";	
			if ((x >= 39 and x <= 470)) and (y >= 39 and y <= 470) then
				ramaddr<=conv_std_logic_vector((conv_integer(addr_start)+(conv_integer(y)-39)/8*54+(conv_integer(x)-39)/8),16);
				if conv_integer(ramdata) = 0 then
					rt <= "000";
					gt	<= "000";
					bt	<= "000";	
				elsif conv_integer(ramdata) = 1 then
					rt <= "111";
					gt	<= "111";
					bt	<= "111";
				elsif conv_integer(ramdata) = 2 then
					rt <= "111";
					gt	<= "000";
					bt	<= "000";
				elsif conv_integer(ramdata) = 3 then
					rt <= "000";
					gt	<= "111";
					bt	<= "000";
				end if;
			elsif (x>470 and y>470) then
				vgaFinish<='1';
			end if;
		end if;
	end process;	

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
	process (hst, vst, rt, gt, bt)	--ɫ�����
	begin
		if hst = '1' and vst = '1' then
			oRed	<= rt;
			oGreen	<= gt;
			oBlue	<= bt;
		else
			oRed	<= (others => '0');
			oGreen	<= (others => '0');
			oBlue	<= (others => '0');
		end if;
	end process;

end behave;
