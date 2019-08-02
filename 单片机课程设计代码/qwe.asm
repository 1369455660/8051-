  		 SEC    DATA   30H		 ;��
		 MIN    DATA   31H		 ;��
		 HOUR   DATA   32H    	 ;ʱ	 
		 ORG    0000H
         SJMP   MAIN
         ORG    000BH			 ;��ʱ���ж�0��� 
         LJMP   IT
         ORG    0030H

MAIN:    MOV    DPTR,#TAB
         MOV    P2,#0			 ;��ʼ�����
         MOV    SEC,#0			 ;�룬�֣�ʱ��Ԫ��0
         MOV    MIN,#0
		 MOV    HOUR,#0
		 MOV    R7,#20			  ;һ��50000us,20�ξ���1s
		 MOV    R0,#30H			  ;��ʾ��Ԫָ��
		 MOV    TMOD,#01H		  ;��ʱ�������������ڷ�ʽ1
		 MOV    TH0,#3CH		  ;��ֵ15536
		 MOV    TL0,#0B0H
		 MOV    IE,#82H
		 SETB   TR0				 ;�����ж�
		 SJMP   $
	

IT:	     MOV    TH0,#3CH		  ;�жϳ���
         MOV    TL0,#0B0H
		 LCALL  KEY
		 DJNZ   R7,EXIT
		 MOV    R7,#20
		 MOV    A,SEC
		 ADD    A,#01H
		 DA     A
		 MOV    SEC,A
		 CJNE   A,#60H,DISP
		 MOV    SEC,#0H
		 MOV    A,MIN
		 ADD    A,#01H
		 DA     A
		 MOV    MIN,A
		 CJNE   A,#60H,DISP
		 MOV    MIN,#0H
		 MOV    A,HOUR
		 ADD    A,#01H
		 MOV    HOUR,A
		 CJNE   A,#24H,DISP
		 MOV    HOUR,#0H
		 RETI

EXIT:    RETI

DISP:    MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.0
		 CLR     P2.0
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.1
		 CLR     P2.1
		 INC     R0
		 MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.2
		 CLR     P2.2
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR 
		 MOV     P1,A
		 SETB    P2.3
		 CLR     P2.3
		 INC     R0
		 MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.4
		 CLR     P2.4
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.5
		 CLR     P2.5
		 MOV     R0,#30H
		 RETI

KEY:     JNB     P3.0,S
         RET

S:       SETB    P3.0

S1:      MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.0
		 CLR     P2.0
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.1
		 CLR     P2.1
		 LCALL   DELAY
		 MOV     A,#0AH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.0
		 SETB    P2.1
		 CLR     P2.0
		 CLR     P2.1
		 LCALL   DELAY
		 SJMP    S1

M:		 SETB    P3.0

         MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.0
		 CLR     P2.0
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.1
		 CLR     P2.1
		 INC     R0
M1:		 MOV     A,@R0		 
         ANL     A,#0FH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.2
		 CLR     P2.2
		 MOV     A,@R0
		 ANL     A,#0F0H
		 SWAP    A
		 MOVC    A,@A+DPTR 
		 MOV     P1,A
		 SETB    P2.3
		 CLR     P2.3
		 LCALL   DELAY1
		 MOV     A,#0AH
		 MOVC    A,@A+DPTR
		 MOV     P1,A
		 SETB    P2.2
		 SETB    P2.3
		 CLR     P2.2
		 CLR     P2.3
		 LCALL   DELAY1
		 SJMP    M1   
H:         
DELAY:        MOV	 R2,#100
D:            MOV    R3,#250
LP2:          JNB    P3.0,M
              DJNZ   R3,LP2
			  DJNZ   R2,D												 s
	          RET 

DELAY1:        MOV	 R2,#100
D1:            MOV    R3,#250
LP21:          JNB    P3.0,H
               DJNZ   R3,LP21
			   DJNZ   R2,D1
	           RET 

TAB:    DB   0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,0FFH

END