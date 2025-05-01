
			; BASIC start
			@basicStart()
			@basicSys(0, start)
			@basicEnd()
start:
			; print text 
			lda #lo(text)
			ldy #hi(text)
			jsr BASIC_ROM_STROUT
			
			rts
text:
			.text "HELLO WORLD"
			.byte 0
