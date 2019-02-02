--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:29:53 11/25/2018
-- Design Name:   
-- Module Name:   D:/zzh_lyh_xcy/CPU/test2.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test2 IS
END test2;
 
ARCHITECTURE behavior OF test2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         rst : IN  std_logic;
         clk_hand : IN  std_logic;
         clk_50 : IN  std_logic;
         dataReady : IN  std_logic;
         tbre : IN  std_logic;
         tsre : IN  std_logic;
         rdn : INOUT  std_logic;
         wrn : INOUT  std_logic;
         ram1En : OUT  std_logic;
         ram1We : OUT  std_logic;
         ram1Oe : OUT  std_logic;
         ram1Data : INOUT  std_logic_vector(15 downto 0);
         ram1Addr : OUT  std_logic_vector(17 downto 0);
         ram2En : OUT  std_logic;
         ram2We : OUT  std_logic;
         ram2Oe : OUT  std_logic;
         ram2Data : INOUT  std_logic_vector(15 downto 0);
         ram2Addr : OUT  std_logic_vector(17 downto 0);
         display_im : OUT  std_logic_vector(15 downto 0);
         display_dm : OUT  std_logic_vector(15 downto 0);
         r0Out : OUT  std_logic_vector(15 downto 0);
         r1Out : OUT  std_logic_vector(15 downto 0);
         r2Out : OUT  std_logic_vector(15 downto 0);
         r3Out : OUT  std_logic_vector(15 downto 0);
         r4Out : OUT  std_logic_vector(15 downto 0);
         r5Out : OUT  std_logic_vector(15 downto 0);
         r6Out : OUT  std_logic_vector(15 downto 0);
         r7Out : OUT  std_logic_vector(15 downto 0);
         dataT : OUT  std_logic_vector(15 downto 0);
         dataSP : OUT  std_logic_vector(15 downto 0);
         dataIH : OUT  std_logic_vector(15 downto 0);
         digit1 : OUT  std_logic_vector(6 downto 0);
         digit2 : OUT  std_logic_vector(6 downto 0);
         led : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk_hand : std_logic := '0';
   signal clk_50 : std_logic := '0';
   signal dataReady : std_logic := '0';
   signal tbre : std_logic := '0';
   signal tsre : std_logic := '0';

	--BiDirs
   signal rdn : std_logic;
   signal wrn : std_logic;
   signal ram1Data : std_logic_vector(15 downto 0);
   signal ram2Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal ram1En : std_logic;
   signal ram1We : std_logic;
   signal ram1Oe : std_logic;
   signal ram1Addr : std_logic_vector(17 downto 0);
   signal ram2En : std_logic;
   signal ram2We : std_logic;
   signal ram2Oe : std_logic;
   signal ram2Addr : std_logic_vector(17 downto 0);
   signal display_im : std_logic_vector(15 downto 0);
   signal display_dm : std_logic_vector(15 downto 0);
   signal r0Out : std_logic_vector(15 downto 0);
   signal r1Out : std_logic_vector(15 downto 0);
   signal r2Out : std_logic_vector(15 downto 0);
   signal r3Out : std_logic_vector(15 downto 0);
   signal r4Out : std_logic_vector(15 downto 0);
   signal r5Out : std_logic_vector(15 downto 0);
   signal r6Out : std_logic_vector(15 downto 0);
   signal r7Out : std_logic_vector(15 downto 0);
   signal dataT : std_logic_vector(15 downto 0);
   signal dataSP : std_logic_vector(15 downto 0);
   signal dataIH : std_logic_vector(15 downto 0);
   signal digit1 : std_logic_vector(6 downto 0);
   signal digit2 : std_logic_vector(6 downto 0);
   signal led : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_hand_period : time := 10 ns;
   constant clk_50_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          rst => rst,
          clk_hand => clk_hand,
          clk_50 => clk_50,
          dataReady => dataReady,
          tbre => tbre,
          tsre => tsre,
          rdn => rdn,
          wrn => wrn,
          ram1En => ram1En,
          ram1We => ram1We,
          ram1Oe => ram1Oe,
          ram1Data => ram1Data,
          ram1Addr => ram1Addr,
          ram2En => ram2En,
          ram2We => ram2We,
          ram2Oe => ram2Oe,
          ram2Data => ram2Data,
          ram2Addr => ram2Addr,
          display_im => display_im,
          display_dm => display_dm,
          r0Out => r0Out,
          r1Out => r1Out,
          r2Out => r2Out,
          r3Out => r3Out,
          r4Out => r4Out,
          r5Out => r5Out,
          r6Out => r6Out,
          r7Out => r7Out,
          dataT => dataT,
          dataSP => dataSP,
          dataIH => dataIH,
          digit1 => digit1,
          digit2 => digit2,
          led => led
        );

   -- Clock process definitions
   clk_hand_process :process
   begin
		clk_hand <= '0';
		wait for 10 ns;
		clk_hand <= '1';
		wait for 10 ns;
   end process;
 
   clk_50_process :process
   begin
		clk_50 <= '0';
		wait for clk_50_period/2;
		clk_50 <= '1';
		wait for clk_50_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='0';
      wait for 100 ns;	
		rst<='1';
      --wait for clk_hand_period*10;

      -- insert stimulus here 

      wait;
   end process;


END;
