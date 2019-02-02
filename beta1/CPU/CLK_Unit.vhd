library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLK_Unit is
	port(	rst,clk_in : in std_logic;
			clk_out : out std_logic
			);
end CLK_Unit;

architecture Behavioral of CLK_Unit is
shared variable clk_count : INTEGER range 0 to 10 := 0;
begin
	process(clk_in,rst)
	begin
		if (rst = '0') then 
			clk_out <= '0';
		elsif (rising_edge(clk_in))then
			case clk_count is
				when 0 =>
					clk_out <= '1';
					clk_count := 1;
				when 1 =>
					clk_out <= '0';
					clk_count := 2;
				when 2 =>
					clk_count := 0;
				when others=>
			end case;
		end if;
	end process;
end Behavioral;

