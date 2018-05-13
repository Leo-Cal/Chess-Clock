library ieee;
use ieee.std_logic_1164.all;


--Somador completo:
entity somador_completo is
   port( X, Y, Cin : in std_logic;
         sum, Cout : out std_logic);
end somador_completo;

architecture  archi of somador_completo is
begin
   sum <= (X xor Y) xor Cin;
   Cout <= (X and (Y or Cin)) or (Cin and Y);
end archi;


library ieee;
use ieee.std_logic_1164.all;

--Somador BCD

entity somador_BCD is 
   port( X3, X2, X1, X0 : in std_logic;
         Y3, Y2, Y1, Y0 : in std_logic;
         S3, S2, S1, S0, Cout : out std_logic);
end somador_BCD;
--Structural architecture
architecture archi of somador_BCD is
 
   component somador_completo is   --FULL ADDER component
   port( X, Y, Cin : in std_logic;
         sum, Cout : out std_logic);
   end component;
   
  --sinais internos
  signal C1, C2, C3, C4, C5, C6: std_logic;--carry do somador completo
  signal FA1, FA2, FA3 : std_logic;--somas internas dos somadores completos
  signal andOut1, andOut2, orOut  : std_logic;

begin

   G_FA0: somador_completo port map(X0, Y0, '0', S0, C1); -- S0
   G_FA1: somador_completo port map(X1, Y1, C1,  FA1, C2);
   G_FA2: somador_completo port map(X2, Y2, C2,  FA2, C3);
   G_FA3: somador_completo port map(X3, Y3, C3,  FA3, C4);	
   --G_A1: andGate port map(FA1, FA3, andOut1);
	andOut1 <= (FA1 and FA3);
	andOut2 <= (FA2 and FA3);
   --G_A2: andGate port map(FA2, FA3, andOut2);
	orOut <= (andOut1 or andOut2 or C4);
   --G_O: orGate port map(andOut2, andOut1, C4, orOut);	
   G_FA4: somador_completo port map(FA1, orOut, '0', S1, C5);-- S1
   G_FA5: somador_completo port map(FA2, orOut,  C5, S2, C6); -- S2
   --G_X : xorGate port map(C6, FA3, S3); -- S3
   S3 <= (C6 xor FA3);
	
	Cout <= orOut; 		 -- Cout
	

end archi;
----------------------------------------------------------END
----------------------------------------------------------END
