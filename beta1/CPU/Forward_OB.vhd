----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:02:52 12/03/2018 
-- Design Name: 
-- Module Name:    Forward_OB - Behavioral 
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

entity Forward_OB is
port(
		ExMemRd : in std_logic_vector(3 downto 0);
		MemWbRd : in std_logic_vector(3 downto 0);
		IdExReg_B : in std_logic_vector(3 downto 0);
		OB_MEM_in : in std_logic_vector(15 downto 0);
		OB_WBMUX_in : in std_logic_vector(15 downto 0);
		OB_in : in std_logic_vector(15 downto 0);
		OB_out : out std_logic_vector(15 downto 0);
		rst : in std_logic
	);
end Forward_OB;

architecture Behavioral of Forward_OB is

begin


end Behavioral;

