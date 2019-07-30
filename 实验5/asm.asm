	   ORG    0000H
	   SJMP   MAIN

MAIN:  
       CLR    P2.0
	   ACALL  LOOP
	   SETB   P2.0
	   ACALL  LOOP	   
	   SJMP   MAIN

LOOP:       
	   MOV	  R2,#200
       MOV    R3,#10
LP1:
LP2:   MOV    B,#248
       NOP
	   DJNZ   B,$
	   DJNZ   R2,LP2
	   DJNZ   R3,LP1
	   RET

	   END
