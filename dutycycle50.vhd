library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library mylib;
use mylib.all;


entity dutycycle50 is  

	port ( Dn_out : in std_logic;
			 Dn_duty : buffer std_logic
			 );			 
			 
end dutycycle50;


architecture archi of dutycycle50 is 

begin

process(Dn_out)
begin
	if(rising_edge(Dn_out)) then
		Dn_duty <= not Dn_duty;
	end if;
end process;		

end archi;