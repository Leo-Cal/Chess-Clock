library ieee;
library mylib;
use mylib.all;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity relogio is 

port ( clk, choose, enable, preset1, preset2, a, b, c, d, modo, modo_player: in std_logic;
		 S0, S1, S2, S3, S4, S5 : out std_logic_vector(6 downto 0); --saidas do 7 segmentos
		 Qtest0,Qtest1,Qtest2,Qtest3,Qtest4,Qtest5,Qtest6,Qtest7 : out std_logic_vector(3 downto 0);  --saidas para testar saidas quaisquer  
		 clk_test : out std_logic; --saida para testar divisao do clock
		 clk_button : in std_logic; --clk no botao para testes
		 rco_test0,rco_test1,rco_test2,rco_test3,rco_test4,rco_test5,rco_test6,rco_test7 : out std_logic; --teste dos rco dos contadores
		 method : in std_logic; --metodo Fischer ou Bronstein
		 delta_in : in std_logic_vector(7 downto 0)); --valor de 2 digitos de delta
		  																						  
		 
end relogio;


architecture archi of relogio is

----------------------____SINAIS INTERNOS___----------------------------
signal clk_1760, clk_440, clk_1000, clk_100, clk_1 : std_logic; 
signal rco0, rco1, rco2, rco3, rco4, rco5, rco6, rco7 : std_logic;
signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : std_logic_vector(3 downto 0);
signal Qmux0_out, Qmux1_out, Qmux2_out, Qmux3_out, Qmux4_out, Qmux5_out : std_logic_vector(3 downto 0);
signal s : std_logic;
signal preset_up, preset_down : std_logic; -- (preset1 or preset2)
signal mux_control : std_logic_vector(1 downto 0);
signal delta, delta_bronstein : std_logic_vector(7 downto 0);  --delta de 2 digitos ( delta(0) a delta(4) eh o primeiro digito)
signal choose_up_edge,choose_down_edge : std_logic;
signal sum_0, sum_1, sum_4, sum_5, total_sum_1,total_sum_5 : std_logic_vector(3 downto 0);
signal co_0, co_1, co_4, co_5, co_total_1, co_total_5 : std_logic;
signal lock : std_logic;
signal delta_bronstein_0, delta_bronstein_1: std_logic_vector(3 downto 0);
----------------------------===============================--------------------

-----------------------____ COMPONENTES___-----------------------
component decimal port 
			( en, CLR_n, up_down, clk, load_n, a, b, c, d, ent : in STD_LOGIC;
			  Q : out std_logic_vector(3 downto 0);
			  enp, rco : out std_logic);
			  
			  end component;

component clkdiv port
			( clk_in  : in std_logic;
			  clk_out_1760hz, clk_out_440hz, clk_out_1000hz, clk_out_100hz, clk_out_1hz: out std_logic;
			  testaconta : out std_logic_vector(3 downto 0);
			  enable : out std_logic;
			  testadiv100 : out std_logic);

end component;			  

component setesegmentos port
			(entrada : in std_logic_vector (3 downto 0);
			 saida : out std_logic_vector (6 downto 0) );
			 
end component;

component mux4to1 port 
			(SEL : in std_logic_vector(1 downto 0);
			 mux_in_0, mux_in_1, mux_in_2, mux_in_3: in std_logic_vector(3 downto 0);
			 Qout : out std_logic_vector(3 downto 0));
			 
end component;	  

component mux2to1_8bits port
			(SEL : in std_logic;
			 mux_in_0, mux_in_1 : in std_logic_vector(7 downto 0);
			 Qout : out std_logic_vector(7 downto 0));
end component;

component edge_detector port 
			(i_clk : in  std_logic;
			i_rstb : in  std_logic;
			i_input : in  std_logic;
			up_edge : out std_logic;
			down_edge : out std_logic);
			
end component;

component somador_BCD port
			(X3, X2, X1, X0 : in std_logic;
          Y3, Y2, Y1, Y0 : in std_logic;
          S3, S2, S1, S0, Cout : out std_logic);
end component;

component bronstein_counter port	
			(en, CLR_n, clk  : in std_logic;
			 Q0, Q1 : out std_logic_vector(3 downto 0);
			 delta_bronstein : in std_logic_vector(7 downto 0);
			 lock : out std_logic);
end component;
---------------------------===========================------------------------------

begin
		
clk_divider : clkdiv port map 
				(clk, clk_1760, clk_440, clk_1000, clk_100, clk_1, open, open, open);  


preset_up <= preset1 or choose_up_edge;
preset_down <= preset1 or choose_down_edge;
clk_test <= clk_100;

--------------------------------_______CONTADORES DOS RELOGIOS_______-------------------------


--up_down em 0 : contagem decrescente
--"not preset_master": load é ativo baixo
--para teste, colocar clk_test nos contadores!!!!
-- player 1 : Q3Q2:Q1Q0  ; player 2 : Q7Q6:Q5Q4
D0 : decimal port map
				(enable , '1', '0', clk, not preset_down, sum_0(0),sum_0(1),sum_0(2),sum_0(3), choose , Q0, open, rco0);
				
D1 : decimal port map
				(enable,  '1', '0', clk, not preset_down, total_sum_1(0), total_sum_1(1), total_sum_1(2), total_sum_1(3), rco0 and choose, Q1, open, rco1);
				
D2 : decimal port map
				(enable,  '1', '0', clk, not preset1, '0','0','0','0', rco1 and rco0 and choose, Q2, open, rco2);
				
D3 : decimal port map
				(enable , '1', '0', clk, not preset1, '1','0','0','0', rco2 and rco1 and rco0 and choose, Q3, open, rco3);

D4 : decimal port map
				(enable , '1', '0', clk, not preset_up, sum_4(0), sum_4(1), sum_4(2), sum_4(3), not choose, Q4, open, rco4);

D5 : decimal port map
				(enable , '1', '0', clk, not preset_up, total_sum_5(0),total_sum_5(1), total_sum_5(2), total_sum_5(3), rco4 and (not choose), Q5, open, rco5);
			
D6 : decimal port map
				(enable , '1', '0', clk, not preset1, '0','0','0','0', rco5 and rco4 and (not choose), Q6, open, rco6);

D7 : decimal port map
				(enable , '1', '0', clk, not preset1, '1','0','0','0', rco6 and rco5 and rco4 and (not choose), Q7, open, rco7);

---------------------------------============================--------------------------------------------------

----------------------Teste de rco dos contadores----------------------
rco_test0 <=rco0;
rco_test1 <= choose_up_edge;
rco_test2 <= rco2;
rco_test3 <= rco3;
rco_test4 <= rco4;
rco_test5 <= rco5;
rco_test6 <= rco6;
rco_test7 <= rco7;
----------------------===========--------------------------------

				
----------------------------________DEFINICAO DO MODO DE JOGO_____------------------------EXP7---------

mux_control(0) <= modo_player;				
mux_control(1) <= modo;

				
mux0 : mux4to1 port map
				(mux_control, Q2, Q2, "0001", "0010", Qmux0_out);

mux1 : mux4to1 port map
				(mux_control, Q3, Q3, Q0, Q4, Qmux1_out);

mux2 : mux4to1 port map
				(mux_control,"1110", "1110", Q1, Q5, Qmux2_out);

mux3 : mux4to1 port map
				(mux_control,"1110", "1110", "1111", "1111", Qmux3_out);

mux4 : mux4to1 port map
				(mux_control, Q6, Q6, Q2, Q6, Qmux4_out);

mux5 : mux4to1 port map
				(mux_control, Q7, Q7, Q3, Q7, Qmux5_out);

----------------------------------=================================------------------------------				
				

-------------------------------------____IMPLEMENTACAO DO METODOS____------------------------------EXP8------------




BRONSTEIN : bronstein_counter port map -- contador pra contar o delta_bronstein
					(enable,not(choose_up_edge or choose_down_edge), clk, delta_bronstein_0, delta_bronstein_1, delta_in, lock);

--Entrada de 8 bits para o multiplexador a partir das saidas de 4 bits do bronstein_counter
delta_bronstein(0) <= delta_bronstein_0(0);
delta_bronstein(1) <= delta_bronstein_0(1);
delta_bronstein(2) <= delta_bronstein_0(2);
delta_bronstein(3) <= delta_bronstein_0(3);
delta_bronstein(4) <= delta_bronstein_1(0);
delta_bronstein(5) <= delta_bronstein_1(1);
delta_bronstein(6) <= delta_bronstein_1(2);
delta_bronstein(7) <= delta_bronstein_1(3);

delta_chooser : mux2to1_8bits port map
				(method, delta_in, delta_bronstein, delta); --escolha do metodo 
				
choose_edge_detector : edge_detector port map
				(clk, '1' ,choose, choose_up_edge, choose_down_edge); --detector de borda para o choose
	
--------------------SOMA DO DELTA--------------	
SOMADOR_0 : somador_BCD port map
				(Q0(3),Q0(2),Q0(1),Q0(0),delta(3),delta(2),delta(1),delta(0),sum_0(3),sum_0(2),sum_0(1),sum_0(0),co_0);
SOMADOR_1 : somador_BCD port map
				(Q1(3),Q1(2),Q1(1),Q1(0),delta(7),delta(6),delta(5),delta(4),sum_1(3),sum_1(2),sum_1(1),sum_1(0),co_1);
TOTAL_SOMADOR_1 : somador_BCD port map
			(sum_1(3),sum_1(2),sum_1(1),sum_1(0),'0','0','0',co_0,total_sum_1(3),total_sum_1(2),total_sum_1(1),total_sum_1(0), co_total_1);

SOMADOR_4 : somador_BCD port map
				(Q4(3),Q4(2),Q4(1),Q4(0),delta(3),delta(2),delta(1),delta(0),sum_4(3),sum_4(2),sum_4(1),sum_4(0),co_4);
SOMADOR_5 : somador_BCD port map
				(Q5(3),Q5(2),Q5(1),Q5(0),delta(7),delta(6),delta(5),delta(4),sum_5(3),sum_5(2),sum_5(1),sum_5(0),co_5);
TOTAL_SOMADOR_5 : somador_BCD port map
			(sum_5(3),sum_5(2),sum_5(1),sum_5(0),'0','0','0',co_4,total_sum_5(3),total_sum_5(2),total_sum_5(1),total_sum_5(0), co_total_5);
--------------------=====================--------------

		

-----------------------=====================================---------------------------------------		

--------------------_____DISPLAY____-----------------------				
				
seg0 : setesegmentos port map
			(Qmux0_out, S0);
seg1 : setesegmentos port map
			(Qmux1_out, S1);
seg2 : setesegmentos port map
			(Qmux2_out, S2);
seg3 : setesegmentos port map
			(Qmux3_out, S3);
seg4 : setesegmentos port map
			(Qmux4_out, S4);
seg5 : setesegmentos port map
			(Qmux5_out, S5);

-------------------------================------------------------

			
--sinais para teste
Qtest0 <= delta_bronstein_0;
Qtest1 <= delta_bronstein_1;
Qtest2 <= Q2;
Qtest3 <= Q3;
Qtest4 <= Q4;
Qtest5 <= Q5;
Qtest6 <= Q6;
Qtest7 <= Q7;
	
			
end archi;