library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity bronstein_count is 

port(en, CLR_n, up_down, clk, ent  : in std_logic;
	  Q : out std_logic_vector(3 downto 0);
	  enp : out std_logic;
	  rco : out std_logic;
	  delta_bronstein : in std_logic_vector(3 downto 0);
	  lock : out std_logic -- sinal pra  travar outros contadores. (1- nao trava , 0 -trava)
	  );
	  
end bronstein_count;

architecture archi of bronstein_count is

signal tmp: std_logic_vector(3 downto 0);
signal s : std_logic;
begin


process (en, CLR_n, clk)  

begin 

	if (CLR_n = '0' and en = '1') then
		tmp <= "0000";
	
	
	elsif (clk'event and clk = '1' and en = '1') then

	
		if (ent = '1') then
	
			if(up_down = '1') then
				if(tmp ="1001") then
					tmp <= "0000";
				else
					tmp <= tmp + 1;
				end if; 
			
			elsif(up_down = '0') then
				if(tmp = "0000") then
					tmp <= "1001";
				else
					tmp <= tmp - 1;
			
			end if;	

			end if; 
			
			
		end if;
		
	
end if;

		if (tmp = delta_bronstein) then
			lock <= '1';
		else 
			lock <= '0';
		end if;

end process;
	
	Q <= tmp;
	
		with tmp select
			rco <= '1' when "1001",
			       '0' when others;
			
		with tmp select
			enp <= '1' when "1001",
			       '0' when others;
		
	
end archi;