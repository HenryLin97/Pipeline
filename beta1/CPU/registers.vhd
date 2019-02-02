library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity registers is
	Port( clk : in std_logic;
			rst : in std_logic;
			RA : in std_logic_vector(3 downto 0);
			RB : in std_logic_vector(3 downto 0);
			WriteReg : in std_logic_vector(3 downto 0);
			WriteData : in std_logic_vector(15 downto 0);
			--out
			OA : out std_logic_vector(15 downto 0);
			OB : out std_logic_vector(15 downto 0);
			--test signals
			r0Out, r1Out, r2Out,r3Out,r4Out,r5Out,r6Out,r7Out : out std_logic_vector(15 downto 0);
			dataT : out std_logic_vector(15 downto 0);
			dataSP : out std_logic_vector(15 downto 0);
			dataIH : out std_logic_vector(15 downto 0);
			--control signals
			--CRA : in std_logic; --if RA needs to be read (useless)
			--CRB : in std_logic; --if RB needs to be read (useless)
			CWB : in std_logic --if write back needs to be implement
			);
end registers;

architecture Behavioral of registers is
	signal r0 : std_logic_vector(15 downto 0);
	signal r1 : std_logic_vector(15 downto 0);
	signal r2 : std_logic_vector(15 downto 0);
	signal r3 : std_logic_vector(15 downto 0);
	signal r4 : std_logic_vector(15 downto 0);
	signal r5 : std_logic_vector(15 downto 0);
	signal r6 : std_logic_vector(15 downto 0);
	signal r7 : std_logic_vector(15 downto 0);
	signal T : std_logic_vector(15 downto 0);
	signal IH : std_logic_vector(15 downto 0);
	signal SP : std_logic_vector(15 downto 0);
begin
	process(clk, rst)
	begin
		if (rst = '0') then
			--r0 <= (others => '0');
			r0 <= "0000000000000000";
			r1 <= "0000000000000000";
			r2 <= (others => '0');
			r3 <= (others => '0');
			r4 <= (others => '0');
			r5 <= (others => '0');
			r6 <= (others => '0');
			r7 <= (others => '0');
			T <= (others => '0');
			IH <= (others => '0');			
			SP <= (others => '0');
		elsif (clk'event and clk='1') then
			if (CWB = '1') then
				case WriteReg is 
					when "0000" => r0 <= WriteData;
					when "0001" => r1 <= WriteData;
					when "0010" => r2 <= WriteData;
					when "0011" => r3 <= WriteData;
					when "0100" => r4 <= WriteData;
					when "0101" => r5 <= WriteData;
					when "0110" => r6 <= WriteData;
					when "0111" => r7 <= WriteData;
					when "1000" => SP <= WriteData;
					when "1001" => IH <= WriteData;
					when "1010" => T <= WriteData;
					when others =>
				end case;
			end if;
		end if;
	end process;
	
	process(RA, RB, r0, r1, r2, r3,r4,r5,r6,r7,SP,IH,T, WriteReg, WriteData)
	begin
		if (RA = WriteReg) and (CWB = '1') then
			OA <= WriteData;
		else
		case RA is 
			when "0000" => OA <= r0;
			when "0001" => OA <= r1;
			when "0010" => OA <= r2;
			when "0011" => OA <= r3;
			when "0100" => OA <= r4;
			when "0101" => OA <= r5;
			when "0110" => OA <= r6;
			when "0111" => OA <= r7;
			when "1000" => OA <= SP;
			when "1001" => OA <= IH;
			when "1010" => OA <= T;
			when others => OA <= (others =>'0');
		end case;
		end if;
		
		if (RB = WriteReg) and (CWB = '1') then
			OB <= WriteData;
		else
		case RB is
			when "0000" => OB <= r0;
			when "0001" => OB <= r1;
			when "0010" => OB <= r2;
			when "0011" => OB <= r3;
			when "0100" => OB <= r4;
			when "0101" => OB <= r5;
			when "0110" => OB <= r6;
			when "0111" => OB <= r7;
			when others => OB <= (others =>'0');
		end case;
		end if;
	end process;
	dataSP <= SP;
	dataIH <= IH;
	dataT <= T;
	
	r0Out <= r0;
	r1Out <= r1;
	r2Out <= r2;
	r3Out <= r3;
	r4Out <= r4;
	r5Out <= r5;
	r6Out <= r6;
	r7Out <= r7;
end Behavioral;
