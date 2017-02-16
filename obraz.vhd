----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:53 03/18/2016 
-- Design Name: 
-- Module Name:    obraz - Behavioral 
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

entity obraz is
 Port ( PX : in  STD_LOGIC_VECTOR (9 downto 0);
           PY : in  STD_LOGIC_VECTOR (9 downto 0);
			  VSIN : in STD_LOGIC;
			  Clk_50MHz : in STD_LOGIC;
			  Mouse_Rdy: in STD_LOGIC;
			  Mouse_status: in STD_LOGIC_VECTOR (7 downto 0);
			  Mouse_x: in STD_LOGIC_VECTOR (7 downto 0);
			  Mouse_y: in STD_LOGIC_VECTOR (7 downto 0);		  
           RGB : out  STD_LOGIC_VECTOR (2 downto 0)
			  );
end obraz;

architecture Behavioral of obraz is

	--signal xint : integer range 0 to 800; 
	--signal yint : integer range 0 to 600;
	signal bila_rys: STD_LOGIC := '0';
	signal kij_rys: STD_LOGIC := '0';
	
	-- BALL
	-- position (10 bits for integral part, 4 - fractional)
	signal polx : unsigned(15 downto 0) := "0000000000000000";
	signal poly : unsigned(15 downto 0) := "0001000000000000";
	-- aliases for above two
	alias polx_calk: unsigned(9 downto 0) is polx(15 downto 6);
	alias polx_ulam: unsigned(5 downto 0) is polx(5 downto 0);
	alias poly_calk: unsigned(9 downto 0) is poly(15 downto 6);
	alias poly_ulam: unsigned(5 downto 0) is poly(5 downto 0);
	
	-- movement (10 bits for integral part, 4 - fractional)
	signal dx : unsigned(15 downto 0) := "0000010000000000";
	signal dy : unsigned(15 downto 0) := "0000010000000000";
	-- aliases for above two
	alias dx_calk: unsigned(9 downto 0) is dx(15 downto 6);
	alias dx_ulam: unsigned(5 downto 0) is dx(5 downto 0);
	alias dy_calk: unsigned(9 downto 0) is dy(15 downto 6);
	alias dy_ulam: unsigned(5 downto 0) is dy(5 downto 0);
	--signal wx : integer range 0 to 800 := 1;
	--signal wy : integer range 0 to 600 := 1;
	
	-- movement vectors directions
	-- vec_direction_x - w osi x // 0 - w prawo; 1 - w lewo
	-- vec_direction_y - w osi y // 0 - w gore; 1 - w dol
	signal vec_direction_x : STD_LOGIC :='0';
	signal vec_direction_y : STD_LOGIC :='1';
	
	-- "ball" side's length
	signal bila : unsigned(4 downto 0) := "10100";
	-- "cue" side's length
	signal kij : unsigned(4 downto 0) := "01100";
	
	-- margin outside the screen
	--signal margin_x : unsigned(7 downto 0) := "01110000";
	--signal margin_y : unsigned(7 downto 0) := "11010100";
	
	-- deceleration
		-- zwalnianie (jednostajnie opozniony)
	-- mnoznik // ustalenie opoznienia/odswiezenie jako ulamka predkosci poczatkowej, poniewaz stala wartosc
	--				dla obu osi nie zadziala dla innego ruchu niz pod katem 0/45/90 etc. stopni
	--signal deceleration_ratio : unsigned(3 downto 0) := "0010";
	--constant deceleration_ratio : integer := 32;
	--signal deceleration_x : unsigned(13 downto 0) := divide ( dx , deceleration_ratio );
	--signal deceleration_y : unsigned(13 downto 0) := divide ( dy , deceleration_ratio );
	--signal deceleration_x : unsigned(15 downto 0) := dx/deceleration_ratio;
	--signal deceleration_y : unsigned(13 downto 0) := dy/deceleration_ratio;
	signal deceleration_x : unsigned(15 downto 0) := "0000000000000001";
	signal deceleration_y : unsigned(15 downto 0) := "0000000000000001";
	--signal deceleration_y : unsigned(13 downto 0) := divide ( dy , deceleration_ratio );
	--deceleration_x <= divide ( dx , deceleration_ratio );  --function is "called" here.
	
	signal Mouse_xx : signed(7 downto 0);
	signal Mouse_yy : signed(7 downto 0);
	-- CUE
	-- position (10 bits for integral part, 4 - fractional)
	signal pol_kij_x : unsigned(15 downto 0) := "0000000000000000";
	signal pol_kij_y : unsigned(15 downto 0) := "0000000000000000";
	-- aliases for above two
	alias pol_kij_x_calk: unsigned(9 downto 0) is pol_kij_x(15 downto 6);
	alias pol_kij_x_ulam: unsigned(5 downto 0) is pol_kij_x(5 downto 0);
	alias pol_kij_y_calk: unsigned(9 downto 0) is pol_kij_y(15 downto 6);
	alias pol_kij_y_ulam: unsigned(5 downto 0) is pol_kij_y(5 downto 0);
	

	
begin

--
-- Drawing
--
process (PX, PY) -- ball drawing
	begin 
		if PX > std_logic_vector(polx_calk) and PX < std_logic_vector(bila+polx_calk) then
			if PY > std_logic_vector(poly_calk) and PY < std_logic_vector(bila+poly_calk) then
				--RGB <= "111"; 
				bila_rys <= '1';
			end if;
		else
			--RGB <="000";
			bila_rys <= '0';
		end if;
end process; 


process (PX, PY) -- cue drawing
	begin 
		if PX > std_logic_vector(pol_kij_x_calk) and PX < std_logic_vector(kij+pol_kij_x_calk) then
			if PY > std_logic_vector(pol_kij_y_calk) and PY < std_logic_vector(kij+pol_kij_y_calk) then
				--RGB <= "101";
				kij_rys <= '1';				
			end if;
		else
			--RGB <="000";
			kij_rys <= '0';
		end if;
end process;

process (PX, PY) -- general drawer
	begin
		if bila_rys = '1' then
			RGB <= "111";
		elsif kij_rys = '1' then
			RGB <= "110";
		else
			RGB <= "000";
		end if;
end process;

--
-- Cue handler
--
process (Mouse_Rdy)
	begin
		if rising_edge(Clk_50MHz) and Mouse_Rdy = '1' then
			if signed(Mouse_x) > 0 then
				pol_kij_x_calk <= pol_kij_x_calk+unsigned(Mouse_x);
			else
				Mouse_xx <= -signed(Mouse_x) + "00000001";
				pol_kij_x_calk <= pol_kij_x_calk-unsigned(Mouse_xx);
			end if;
		end if;	
end process;

process (Mouse_Rdy)
	begin
		if rising_edge(Clk_50MHz) and Mouse_Rdy = '1' then
			if signed(Mouse_y) > 0 then
				pol_kij_y_calk <= pol_kij_y_calk-unsigned(Mouse_y);
			else
				Mouse_yy <= -signed(Mouse_y) + "00000001";
				pol_kij_y_calk <= pol_kij_y_calk+unsigned(Mouse_yy);
			end if;
		end if;	
end process;

--
-- Ball movement mechanics
--
process (VSIN) -- deceleration x
	begin
		if rising_edge(VSIN) then
			if deceleration_x > dx then
				dx <= "0000000000000000";
			else
				dx <= dx-deceleration_x;
			end if;
				--deceleration_x <= divide ( dx , deceleration_ratio );
		end if;
end process;

process (VSIN) -- deceleration y
	begin
		if rising_edge(VSIN) then
			if deceleration_y > dy then
				dy <= "0000000000000000";
			else
				dy <= dy-deceleration_y;
			end if;
				--deceleration_y <= divide ( dy , deceleration_ratio );
		end if;
end process;

process (VSIN) -- movement x
	begin
		if rising_edge(VSIN) then
		-- przesuniecie w osi x
			if vec_direction_x = '0' then
				polx <= polx+dx;
			else
				polx <= polx-dx;
			end if;
		end if;
end process;
			
process (VSIN) -- movement y
	begin
		if rising_edge(VSIN) then			
		-- przesuniecie w osi y
			if vec_direction_y = '0' then
				poly <= poly-dy;
			else
				poly <= poly+dy;
			end if;
		end if;
end process;

process (VSIN) -- collisions
	begin			
		if rising_edge(VSIN) then
		-- odbicie w osi x
			if polx_calk >= to_unsigned(800,polx_calk'length)-bila and polx_calk < to_unsigned(900,polx_calk'length)-bila then--or polx_calk <= to_unsigned(1, polx_calk'length) then
				vec_direction_x <= '1';
			elsif polx_calk <= to_unsigned(1, polx_calk'length) or polx_calk >= to_unsigned(900,polx_calk'length) then -- <- doesn't work if ball's moving too fast
				vec_direction_x <= '0';
			end if;
			
		-- odbicie w osi y
			if poly_calk >= to_unsigned(600,poly_calk'length)-bila and poly_calk < to_unsigned(700,poly_calk'length)-bila then
				vec_direction_y <= '0';
			elsif poly_calk <= to_unsigned(1, poly_calk'length) or poly_calk >= to_unsigned(700,poly_calk'length) then
				vec_direction_y <= '1';
			end if;
		end if;
end process;

end Behavioral;
