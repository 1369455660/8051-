	      ORG       0000H
	      SJMP      MAIN
	      ORG       0030H


MAIN:     CLR       A
          MOV       R0,#30H
CLR1:     MOV       @R0,A
          INC       R0
		  CJNE      R0,#34H,CLR1

		  MOV       R7,#24
LOOP:     CLR       C
          MOV       A,R4
		  RLC       A
		  MOV       R4,A
		  MOV       A,R3
		  RLC       A
		  MOV       R3,A
		  MOV       A,R2
		  RLC       A
		  MOV       R2,A
		  MOV       F0,C
		  MOV       R1,#33H
DAD:      MOV       C,F0
          MOV       A,@R1
		  ADDC      A,@R1
		  DA        A
		  MOV       @R1,A
		  DEC       R1
		  MOV       F0,C
		  CJNE      R1,#2FH,DAD
		  DJNZ      R7,LOOP
		  SJMP      $
		  END



		     