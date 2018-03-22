----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:45 03/13/2018 
-- Design Name: 
-- Module Name:    finite_state_machine - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity finite_state_machine is
    Port ( a0 : in  STD_LOGIC_VECTOR (7 downto 0);
           a1 : in  STD_LOGIC_VECTOR (7 downto 0);
           a2 : in  STD_LOGIC_VECTOR (7 downto 0);
           a3 : in  STD_LOGIC_VECTOR(7 downto 0);
           nxt : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  clk : in STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (16 downto 0));
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component wallace8 is
	Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           prod : out  STD_LOGIC_VECTOR (15 downto 0));
			  
end component;

signal curr_s : std_logic_vector (1 downto 0) := (others => '0');
signal k1 : std_logic_vector ( 15 downto 0);
signal k2 : std_logic_vector (15 downto 0);
signal k3 : std_logic_vector (15 downto 0);
signal k4 : std_logic_vector (15 downto 0);
--signal temp : std_logic_vector (1 downto 0) := (others => '0');

begin

wa00: wallace8 port map(a0,a1,k1);
wa01: wallace8 port map(a2,a3,k2);
wa02: wallace8 port map(a0,a2,k3);
wa03: wallace8 port map(a1,a3,k4);

process(nxt,clk,reset)
begin
	if(reset = '1') then
		curr_s <= "00";
	else if(reset = '0' and rising_edge(clk)) then 
		
		if(curr_s = "00" and nxt = '1') then
			curr_s <= "01";
		elsif (curr_s = "01" and nxt = '1') then
			curr_s <= "10";
		elsif (curr_s = "10" and nxt = '1') then 
			curr_s <= "11";
		elsif (curr_s = "11" and nxt = '1') then
			curr_s <= "00";
		end if;
	end if;
	end if;
end process;

process(a0,a1,a2,a3,curr_s,reset,clk)
begin
	if(reset = '1') then
		output <= "00000000000000000";
	else if(reset ='0' and rising_edge(clk)) then
		if(curr_s = "00") then
			output <= ("000000000" & a0) + ("000000000" & a1) + ("000000000" & a2) + ("000000000"  & a3);
		elsif(curr_s = "01") then
			output <= ('0' & k1);
		elsif(curr_s = "10") then
			output <= ('0' & k2);
		elsif(curr_s = "11") then
			output <= ('0' & k3) + ('0' & k4);
		end if;
	end if;
	end if;



end process;





end Behavioral;

