; Print.asm
; Use basic rom to print to screen
; (c) Morten Perriartd 2026

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
			@basicEnd()
start:
			; text pointer in a=lo, y=hi
			@lday(text)
			jsr BASIC_ROM_STROUT
			rts

text:		.text "HELLO WORLD"
			.byte 0
