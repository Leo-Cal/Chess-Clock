library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux2to1_8bits is

port (SEL : in std_logic;
	   mux_in_0, mux_in_1 : in std_logic_vector(7 downto 0);
	   Qout : out std_logic_vector(7 downto 0)
	  );
	 
end mux2to1_8bits;

architecture archi of mux2to1_8bits is

begin

	with SEL select
		Qout <=  mux_in_0 when '0',
					mux_in_1 when '1';
					

end archi;