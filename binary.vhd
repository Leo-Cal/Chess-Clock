library ieee;
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity binary is

port(en, CLR_n, up_down, clk, load_n, a,b,c,d : in std_logic;
     Q : out std_logic_vector(3 downto 0);
	  enp, rco : out std_logic
	  );

end binary;


architecture archi of binary is

signal tmp: std_logic_vector(3 downto 0);

begin

process (en, CLR_n, clk)    --esse parenteses significa o q exatamente? e pq o load_n n aparece aqui? Seria pq ele n aciona process nenhum?
            
begin
				
	if (CLR_n = '0' and en = '1') then  --clr é ativo baixo
		
		tmp <= "0000";

   elsif (clk'event and clk='1' and en = '1') then

		if (load_n = '0') then  --load é ativo baixo
			
			tmp(0) <= a;
			tmp(1) <= b;
			tmp(2) <= c;
			tmp(3) <= d;
				 
		elsif (up_down = '1') then
         
			tmp <= tmp + 1;

      else  --up_down = '0'
		
			tmp <= tmp - 1;
			
		end if;

	
		if (tmp = "1111") then 
			
			rco <= '1';
			enp <= '1';
			
		else 
			
			rco <= '0';
			enp <= '0';
			
		end if;

	end if;

            
end process;

      Q <= tmp;
		
end archi;
