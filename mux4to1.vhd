library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux4to1 is

port (SEL : in std_logic_vector(1 downto 0);
	   mux_in_0, mux_in_1, mux_in_2, mux_in_3: in std_logic_vector(3 downto 0);
	   Qout : out std_logic_vector(3 downto 0)
	  );
	 
end mux4to1;

architecture archi of mux4to1 is

begin

	with SEL select
		Qout <=  mux_in_0 when "00",
					mux_in_1 when "01",
					mux_in_2 when "10",
					mux_in_3 when "11";

end archi;