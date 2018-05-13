library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library mylib;
use mylib.all;


entity clkdiv is 

	port ( clk_in : in STD_LOGIC;
			 clk_out_1760hz : out STD_LOGIC;
			 clk_out_440hz : out STD_LOGIC;
			 clk_out_1000hz : out STD_LOGIC;
			 clk_out_100hz : out STD_LOGIC;
			 clk_out_1hz : out STD_LOGIC;
			 testaconta : out std_logic_vector(3 downto 0);
			 enable : out std_logic;
			 --testadiv5 : out std_logic;
			 --testadiv10 : out std_logic;
			 testadiv100 : out std_logic
			 --testadiv1000 : out std_logic
			 --testacontdiv5 : out std_logic_vector(3 downto 0)
			 );			 
			 
end clkdiv;


architecture archi of clkdiv is

---------------------------------------------------------------------------------------------------------Signal
signal C0 : std_logic;  --o clock de 50Mhz



--SAÍDAS que serão cascateadas. São RCO's ou valores outputs tais que clk / 5 ou 15
signal Dcom_out : STD_LOGIC; --/5 
                                                   
signal D1left_out, D2left_out, D3left_out, D4left_out, D5left_out, D6left_out, D7left_out : STD_LOGIC;   --rco   

signal D1right_out, D2right_out : STD_LOGIC;    --/15                                                        

signal D3rightright_out, D4rightright_out : std_logic; --rightright, para /10, obtendo 440 Hz  --rco
signal D3rightleft_out, D4rightleft_out : STD_LOGIC; --rightleft, para /5, obtendo 1760 Hz
																															
--CONTAGENS de 4 bits
signal Dcom_count, D1right_count, D2right_count, D3rightleft_count, D4rightleft_count : std_logic_vector (3 downto 0);  

--clr_n para os respectivos contadores
signal clr_n_Dcom, clr_n_D1right, clr_n_D2right, clr_n_D3rightleft, clr_n_D4rightleft : std_logic;
signal D4left_duty, D5left_duty, D7left_duty, D4rightleft_duty, D4rightright_duty  : std_logic;
signal D4left_duty_n, D5left_duty_n, D7left_duty_n, D4rightleft_duty_n, D4rightright_duty_n  : std_logic;

--Para ajustar o duty-cycle
signal testadutydiv5, testadutydiv10, testadutydiv100, testadutydiv1000 : std_logic;
--signal testadutydiv5_n, testadutydiv10_n, testadutydiv100_n, testadutydiv1000_n : std_logic;

signal aaa : std_logic_vector(3 downto 0);
signal enablego : std_logic;
-----------------------------------------------------------------------------------------------------Contadores
component decimal port 
			( en, CLR_n, up_down, clk, load_n, a, b, c, d, ent : in STD_LOGIC;
			  Q : out std_logic_vector(3 downto 0);
			  enp, rco : out std_logic
			 );
end component;


component binary port
			( en, CLR_n, up_down, clk, load_n, a, b, c, d : in STD_LOGIC;
			  Q : out std_logic_vector(3 downto 0);
			  enp, rco : out std_logic);
end component;

component dividen port    --contador binario para dividir por numeros sem usar rco
			(clk_in      : in std_logic;
			 clkdivn_out : out std_logic;
			 div_numero  : in std_logic_vector(3 downto 0);
			 contador    : out std_logic_vector(3 downto 0)
			 );
end component;

component dutycycle50 port
			( Dn_out : in std_logic;
			 Dn_duty : out std_logic
			 );
end component;

begin


C0 <= clk_in;
enable <= enablego;

-----------------------------------------------------------------------ramo comum da clock tree (Divisão por 5)
Dcom : dividen port map      --divisão por 5
		(C0, Dcom_out, "0101", open );

--process(Dcom_out)     --obs leitura de divisao por 10
--begin
	--if(rising_edge(Dcom_out)) then
		--testadutydiv5 <= not testadutydiv5;
	--end if;
--end process;
--testadiv5 <= testadutydiv5;


--------------------------------------------------------------------Esquerda da clock tree: para 1k, 100 e 1 Hz
		
D1left : dividen port map
		(Dcom_out, D1left_out, "0101", open );
		

--process(D1left_out)
--begin
	--if(rising_edge(D1left_out)) then
		--testadutydiv10 <= not testadutydiv10;
	--end if;
--end process;
--testadiv10 <= testadutydiv10;
---------------------------------------------------------------------------------------------------------------
D2left : decimal port map
		('1', '1', '1', D1left_out, '1', '0', '0', '0', '0', '1', open, open,  D2left_out);


--process(D2left_out)
--begin
----	if(rising_edge(D2left_out)) then
--		testadutydiv100 <= not testadutydiv100;
--	end if;
--end process;
--testadiv100 <= testadutydiv100;
testadiv100 <= D2left_out;
---------------------------------------------------------------------------------------------------------------
D3left : decimal port map
		('1', '1', '1', D2left_out, '1', '0', '0', '0', '0', '1', open, open, D3left_out);


--process(D3left_out)
--begin
	--if(rising_edge(D3left_out)) then
		--testadutydiv1000 <= not testadutydiv1000;
	--end if;
--end process;
--testadiv1000 <= testadutydiv1000;
---------------------------------------------------------------------------------------------------------------
D4left : decimal port map
		('1', '1', '1', D3left_out, '1', '0', '0', '0', '0','1', open, open, D4left_out);   --D4left_out = 1 kHz

---------------------------------------------------------------------------------------------------------------
D5left : decimal port map
		('1', '1', '1', D4left_out, '1', '0', '0', '0', '0','1', open, open, D5left_out);   --D5left_out = 100 Hz

---------------------------------------------------------------------------------------------------------------		
D6left : decimal port map
		('1', '1', '1', D5left_out, '1', '0', '0', '0', '0', '1', open, open, D6left_out);

---------------------------------------------------------------------------------------------------------------		
D7left : decimal port map
		('1', '1', '1', D6left_out, '1', '0', '0', '0', '0','1', open, open, D7left_out);   --D7left_out = 1 Hz

		
D4left_clkduty50 : dutycycle50 port map
		(D4left_out, clk_out_1000hz);


		
D5left_clkduty50 : dutycycle50 port map
		(D5left_out, clk_out_100hz);



D7left_clkduty50 : dutycycle50 port map
		(D7left_out, clk_out_1hz);


		
------------------------------------------------------------------------------Ramo da direita: 1760 Hz e 440 Hz
		
D1right : dividen port map   --/contador binario dividindo por 15
		(Dcom_out, D1right_out, "1001", open);


D2right : dividen port map   --/contador binario dividindo por 15
		(D1right_out, D2right_out, "1001", open);
		

------------------------------------------------------------------Ramo da direita, sub-ramo da esquerda: 1760 Hz
D3rightleft : dividen port map   --/5
		(D2right_out, D3rightleft_out, "0111", open);

D4rightleft : dividen port map   --/5
		(D3rightleft_out, D4rightleft_out, "0101", open);			

		
D4rightleft_clkduty50 : dutycycle50 port map
		(D4rightleft_out, clk_out_1760hz);		



------------------------------------------------------------------Ramo da direita, sub-ramo da direita: 440 Hz
		
D3rightright : dividen port map
		(D2right_out, D3rightright_out, "1110", open);

		
D4rightright : decimal port map
		('1', '1', '1', D3rightright_out, '1', '0', '0', '0', '0', '1', open, open, D4rightright_out);


D4rightright_clkduty50 : dutycycle50 port map
		(D4rightright_out, clk_out_440hz);		



--Dtest : decimal port map
---('1', '1', '1', D7left_duty, '1', '0', '0', '0', '0',  aaa, open, open);
--testaconta <= aaa;
end archi;	