	MSED	DATA	30H;msecond
	SED		DATA	31H;second
	MIN		DATA	32H;minute
	HUR		DATA	33H;hour
	KECD	DATA	34H;original key code
	PST		DATA	35H;position,0:hour;1:minute;2:second
	STA		BIT		20H;state flag,0:runing state; 1:modify state
	KEYOK	BIT		21H;key process flag,0:not processed;1:processed

		ORG		0000H
		LJMP	MAIN
		ORG		000BH
		LJMP	INTR
		ORG		0030H
MAIN:	MOV		SED,#50H;the original value of timer
		MOV		MIN,#50H
		MOV		HUR,#08H
		MOV		MSED,#0
		CLR		STA;the orignal state=0
		MOV		PST,#0;select hour postion

		MOV		TMOD,#1;timer 0,time mode 1;
		MOV		TH0,#0D8H;10 ms timer
		MOV		TL0,#0F0H
		MOV		IE,#82H
		SETB	TR0
DISP:	
		MOV		DPTR,#TAB
		MOV		A,SED;√Î
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.0
		CLR		P2.0
		MOV		A,SED
		SWAP	A
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.1
		CLR		P2.1

		MOV		A,MIN;∑÷
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.2
		CLR		P2.2
		MOV		A,MIN
		SWAP	A
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.3
		CLR		P2.3

		MOV		A,HUR;  ±
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.4
		CLR		P2.4
		MOV		A,HUR
		SWAP	A
		ANL		A,#0FH
		MOVC	A,@A+DPTR
		MOV		P1,A
		SETB	P2.5
		CLR		P2.5
		
		MOV		C,STA;read state,check it should glitter
		JNC		SLP;need not glitter
		MOV		A,MSED
		SUBB	A,#90
		JC		SLP;need not clear led
		MOV		A,PST;read position
		CJNE	A,#0,GLT1
		MOV		P1,#0FFH;clear hour uint
		SETB	P2.4
		CLR		P2.4
		SETB	P2.5
		CLR		P2.5
		SJMP	SLP
GLT1:	CJNE	A,#1,GLT2
		MOV		P1,#0FFH;clear minute uint
		SETB	P2.2
		CLR		P2.2
		SETB	P2.3
		CLR		P2.3
		SJMP	SLP		
GLT2:	CJNE	A,#2,SLP
		MOV		P1,#0FFH;clear second uint
		SETB	P2.1
		CLR		P2.1
		SETB	P2.0
		CLR		P2.0		
SLP:	MOV		A,SED; open alarm
		JNZ		SLP1
		MOV		A,MIN
		JNZ		SLP1
		SETB	P2.6
		SJMP	SLP2	
SLP1:	CLR		P2.6
SLP2:	ORL		PCON,#1
		LJMP	DISP

TAB:	DB		0C0H,0F9H,0A4H,0B0H,99H,92H
		DB		82H,0F8H,80H,90H

INTR:	MOV		TH0,#0D8H
		MOV		TL0,#0F0H
		LCALL	KEY	;deal with input key
		INC		MSED
		MOV		A,MSED
		CJNE	A,#100,EXT
		MOV		MSED,#0;clear msed
					
		MOV		A,SED;modify second
		ADD		A,#1
		DA		A
		MOV		SED,A
		CJNE	A,#60H,EXT
		MOV		SED,#0;clear second
	
		MOV		A,MIN;modify minute
		ADD		A,#1
		DA		A
		MOV		MIN,A
		CJNE	A,#60H,EXT
		MOV		MIN,#0;clear minute

		MOV		A,HUR;modify hour
		ADD		A,#1
		DA		A
		MOV		HUR,A
		CJNE	A,#24H,EXT
		MOV		HUR,#0;clear hour
EXT:	RETI

KEY:    MOV		A,P3
		CPL		A
		ANL		A,#3
		JNZ		KEY0;does not enter any key,return
		CLR		KEYOK;clear keyok flag
		LJMP	        KEXT			
KEY0:	XCH		A,KECD;store current key code
		XRL		A,KECD;the same key as last time
		JZ		KEY1
		CLR		KEYOK;clear a key flag 	
		LJMP	KEXT
KEY1:	JB		KEYOK,KEXT;the key is already processed
		SETB	KEYOK;set keyok flag
		MOV		A,KECD;excecute key task
		CJNE	A,#1,KWK2
KWK1:	MOV		C,STA;read systme state
		JC		KWK10;is runing state?
		SETB	STA;into modify state
		MOV		PST,#0;display postion is set hour
		LJMP	KEXT;ruturn
KWK10:	INC		PST;if it in modify state,increase postion number
		MOV		A,PST
		CJNE	A,#3,KEXT;if it is bigger than the max postion,clear it	
		MOV		PST,#0;
		CLR		STA;into runing state	
		LJMP	KEXT;
KWK2:	MOV		C,STA
		JNC		KEXT;in runing state,do not respond inc key
		MOV		A,PST
		JNZ		KWK21;increase hour
		MOV		A,HUR
		ADD		A,#1
		DA		A
		CJNE	A,#24H,KWK20;
		CLR		A;clear hour
KWK20:	MOV		HUR,A
		LJMP	KEXT
KWK21:	MOV		A,PST
		CJNE	A,#1,KWK23
		MOV		A,	MIN
		ADD		A,#1
		DA		A
		CJNE	A,#60H,KWK22
		CLR		A;clear minute
KWK22:	MOV		MIN,A
		LJMP	KEXT
KWK23:	MOV		A,PST
		CJNE	A,#2,KEXT
		MOV		A,SED
		ADD		A,#1
		DA		A
		CJNE	A,#60H,KEY24
		CLR		A;clear second
KEY24:	MOV		SED,A;
KEXT:	RET	
		END