--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:46:21 05/24/2016
-- Design Name:   
-- Module Name:   C:/Users/lab/Desktop/NF/projektucisw/test.vhd
-- Project Name:  projektucisw
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: obraz
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
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT obraz
    PORT(
         PX : IN  std_logic_vector(9 downto 0);
         PY : IN  std_logic_vector(9 downto 0);
         VSIN : IN  std_logic;
         Clk_50MHz : IN  std_logic;
         Mouse_Rdy : IN  std_logic;
         Mouse_status : IN  std_logic_vector(7 downto 0);
         Mouse_x : IN  std_logic_vector(7 downto 0);
         Mouse_y : IN  std_logic_vector(7 downto 0);
         RGB : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PX : std_logic_vector(9 downto 0) := (others => '0');
   signal PY : std_logic_vector(9 downto 0) := (others => '0');
   signal VSIN : std_logic := '0';
   signal Clk_50MHz : std_logic := '0';
   signal Mouse_Rdy : std_logic := '0';
   signal Mouse_status : std_logic_vector(7 downto 0) := (others => '0');
   signal Mouse_x : std_logic_vector(7 downto 0) := (others => '0');
   signal Mouse_y : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal RGB : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant Clk_50MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: obraz PORT MAP (
          PX => PX,
          PY => PY,
          VSIN => VSIN,
          Clk_50MHz => Clk_50MHz,
          Mouse_Rdy => Mouse_Rdy,
          Mouse_status => Mouse_status,
          Mouse_x => Mouse_x,
          Mouse_y => Mouse_y,
          RGB => RGB
        );

   -- Clock process definitions
   Clk_50MHz_process :process
   begin
		Clk_50MHz <= '0';
		wait for Clk_50MHz_period/2;
		Clk_50MHz <= '1';
		wait for Clk_50MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clk_50MHz_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
