library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
	port(	rst,clk : in std_logic;
			PCKeep : in std_logic;
			PCIn : in std_logic_vector(15 downto 0);
			PCOut : out std_logic_vector(15 downto 0)
			);
end PC;

architecture Behavioral of PC is
begin
	process(clk,rst)
	begin
		if (rst = '0') then 
			PCOut <= "0000000000000000";
		elsif (clk'event and clk='1')then
			if PCKeep = '0' then
				PCOut <= PCIn;
				--PCOut <= PCIn + "0000000000000001";
			end if;
		end if;
	end process;
end Behavioral;

