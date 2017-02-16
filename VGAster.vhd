----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:06 03/18/2016 
-- Design Name: 
-- Module Name:    VGAster - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAster is
 Port ( RGB : in  STD_LOGIC_VECTOR (2 downto 0);
           Clk_50MHz : in  STD_LOGIC;
           R : out  STD_LOGIC;
           G : out  STD_LOGIC;
           B : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
			  VSync : out STD_LOGIC;
           PX : out  STD_LOGIC_VECTOR (9 downto 0);
           PY : out  STD_LOGIC_VECTOR (9 downto 0));
end VGAster;

architecture Behavioral of VGAster is
	signal xcounter : integer range 0 to 1039; 
	signal ycounter : integer range 0 to 665; 
begin
	process (Clk_50MHz) 
	begin 
		if rising_edge(Clk_50MHz) then 
			if xcounter = 1039 then 
				xcounter <= 0; 
				if ycounter = 665 then 
					ycounter <= 0; 
				else 
					ycounter <= ycounter + 1; 
				end if; 
			else 
				xcounter <= xcounter + 1; 
			end if; 
		end if; 
	end process; 

	HS <= '0' when xcounter >= 56 and xcounter < 176 else '1'; 
	VS <= '0' when ycounter >= 37 and ycounter < 43 else '1'; 
	
	VSync <= '0' when ycounter >=37 and ycounter <43 else '1';
	
	process (xcounter, ycounter, RGB) 
	begin 
		if xcounter < 240 or ycounter < 66 then 
			R <= '0'; 
			G <= '0'; 
			B <= '0'; 
			PX <= std_logic_vector(to_unsigned(800, PX'length)); 
			PY <= std_logic_vector(to_unsigned(600, PY'length)); 
		else 
			R <= RGB(2); 
			G <= RGB(1); 
			B <= RGB(0); 
			PX <= std_logic_vector(to_unsigned(xcounter - 240, PX'length)); 
			PY <= std_logic_vector(to_unsigned(ycounter - 66, PY'length)); 
		end if; 
	end process; 


end Behavioral;

