library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library mylib;
use mylib.all;


entity dividen is 

port(clk_in      : in std_logic;
	  clkdivn_out : out std_logic;
	  div_numero  : in std_logic_vector(3 downto 0);
	  contador    : out std_logic_vector(3 downto 0)
	  );
			  
end dividen;
		  
architecture archi of dividen is

component binary port 
			( en, CLR_n, up_down, clk, load_n, a, b, c, d : in STD_LOGIC;
			  Q : out std_logic_vector(3 downto 0);
			  enp, rco : out std_logic);
			  
end component;

signal Dcont_count : std_logic_vector(3 downto 0);
signal Dcont_out, clr_n_Dcont : std_logic;
signal C0 : std_logic;
signal denominador : std_logic_vector(3 downto 0);

begin
C0 <= clk_in;
Dcont: binary port map ('1', clr_n_Dcont, '1', C0, '1', '0', '0', '0', '0', Dcont_count, open, open);

denominador <= div_numero;
contador <= Dcont_count;
clkdivn_out <= Dcont_out;

process(C0)
begin
	if(C0'event and C0 = '1') then
		if(Dcont_count = div_numero - "0010") then
			Dcont_out <= '1';
			
		else
			Dcont_out <= '0';
		
		end if;
	end if;
	
	if(Dcont_out = '1') then
		clr_n_Dcont <= '0';
	else
		clr_n_Dcont <= '1';
	end if;
		
end process;


end archi;