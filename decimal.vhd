library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decimal is

port(en, CLR_n, up_down, clk, load_n, a, b, c, d, ent  : in std_logic;
	  Q : out std_logic_vector(3 downto 0);
	  enp : out std_logic;
	  rco : out std_logic
	  );
	  
end decimal;

architecture archi of decimal is

signal tmp: std_logic_vector(3 downto 0);
signal start : std_logic_vector(3 downto 0);
signal s : std_logic;
begin


process (en, CLR_n, clk)  --significaria isso q um process começa a cada vez q um desses caras muda?

begin 

	if (CLR_n = '0' and en = '1') then
		tmp <= "0000";
	
	
	elsif (clk'event and clk = '1' and en = '1') then

		if (load_n = '0') then
			tmp(0) <= a;
			tmp(1) <= b;
			tmp(2) <= c;
			tmp(3) <= d;
	
	
		elsif (ent = '1') then
	
			if(up_down = '1') then
				if(tmp ="1001") then
					tmp <= "0000";
				else
					tmp <= tmp + 1;
				end if; --if39
			
			elsif(up_down = '0') then
				if(tmp = "0000") then
					tmp <= "1001";
				else
					tmp <= tmp - 1;
				end if; --if46
			
			end if; --if38
		
		end if;
		

			
		--if(tmp = "1000" and up_down = '1') then
			--rco <= '1';
		--	enp <= '1';
		--elsif (tmp = "0001" and up_down = '0') then
			--rco <= '1';
			--enp <= '1';
		--else
			--rco <= '0';
			--enp <= '0';
	---	end if; --if54
		
		--end if; --if29
	end if;	--if27

end process;
	
	Q <= tmp;
	
		with tmp select
			rco <= '1' when "0000",
			       '0' when others;
			
		with tmp select
			enp <= '1' when "0000",
			       '0' when others;
	
end archi;