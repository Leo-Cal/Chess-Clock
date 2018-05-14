library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity bronstein_counter is 

port (en, CLR_n, clk : in std_logic;
	  Q0, Q1 : out std_logic_vector(3 downto 0);
	  delta_bronstein : in std_logic_vector(7 downto 0);
	  lock : out std_logic); -- sinal pra  travar outros contadores. (1- nao trava , 0 -trava)
	  --test0, test1 : out std_logic);
end bronstein_counter;

architecture archi of bronstein_counter is 

signal lock_0, lock_1 : std_logic;
signal lock_master : std_logic;
signal rco0,rco1 : std_logic;
signal delta_bronstein_0, delta_bronstein_1 : std_logic_vector(3 downto 0);
signal enp : std_logic;

component bronstein_count port
	 (en, CLR_n, up_down, clk, ent  : in std_logic;
	  Q : out std_logic_vector(3 downto 0);
	  enp : out std_logic;
	  rco : out std_logic;
	  delta_bronstein : in std_logic_vector(3 downto 0);
	  lock : out std_logic -- sinal pra  travar outros contadores
	  );
end component;

begin 

lock_master <= lock_0 and lock_1;
delta_bronstein_0(0) <= delta_bronstein(0);
delta_bronstein_0(1) <= delta_bronstein(1);
delta_bronstein_0(2) <= delta_bronstein(2);
delta_bronstein_0(3) <= delta_bronstein(3);
delta_bronstein_1(0) <= delta_bronstein(4);
delta_bronstein_1(1) <= delta_bronstein(5);
delta_bronstein_1(2) <= delta_bronstein(6);
delta_bronstein_1(3) <= delta_bronstein(7);

CONT_Q0 : bronstein_count port map 
			((en and not(lock_master)),CLR_n,'1',clk,'1',Q0,enp,rco0,delta_bronstein_0,lock_0);
CONT_Q1 : bronstein_count port map
			((en and not(lock_master)),CLR_n,'1',clk,rco0,Q1,enp,rco1,delta_bronstein_1,lock_1);

				
			
end archi;			

