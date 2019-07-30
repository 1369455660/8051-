		   ORG   0000H
		   AJMP  MAIN
		   ORG   001BH
		   AJMP  IT1P
		 
MAIN: 	   MOV   R1,#00H
		   MOV   DPTR,#2100H
		   MOV   R0,#14H
		   MOV   TMOD,#10H
		   MOV   TL1,#0B0H
		   MOV   TH1,#03CH
		   SETB  ET1
		   SETB  TR1
		   SETB  EA
		   SJMP  $

IT1P:      MOV   TL1,#0B0H
           MOV   TH1,#03CH
		   DJNZ  R0,EXIT
		   MOV   R0,#14H
		   INC   R1
		   CJNE  R1,#08H,LED
		   MOV   R1,#00H

LED:       MOV   A,R1
           MOVC  A,@A+DPTR
           MOV   P2,A	   
		 
EXIT:      RETI
		   
		   ORG   2100H
		   DB    0FFH,0FAH,0F5H,0AFH,05FH,0AAH,055H,00H,0FFH
		    			
		   END