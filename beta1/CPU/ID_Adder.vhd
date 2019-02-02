----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:15:14 11/22/2016 
-- Design Name: 
-- Module Name:    PCAdder - Behavioral 
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_Adder is
	port( adderIn1 : in std_logic_vector(15 downto 0);
			adderIn2 : in std_logic_vector(15 downto 0);
			adderOut : out std_logic_vector(15 downto 0)
			);
end ID_Adder;

architecture Behavioral of ID_Adder is

begin
	process(adderIn1, adderIn2)
	begin
		adderOut <= adderIn1 + adderIn2 + 1;
	end process;

end Behavioral;

