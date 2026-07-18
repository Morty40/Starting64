; RNG.asm
; Pseudo random number generator
; (c) Morten Perriartd 2026

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
			@basicEnd()
			
SCREEN		= $0400
			
start:
			; seed the RNG
			lda #42
			jsr rngSeed
			
			; generate random chars on screen
			ldx #0
_0:
			jsr rngNext
			sta SCREEN,x
			inx
			bne _0
			rts

; AX+ Tinyrand8
; https://codebase64.net/doku.php?id=base:ax_tinyrand8
; A fast 8-bit random generator with an internal 16bit state

; constants 217 and 21263 have been derived by simulation
RNG_SEED_MAGIC1 = 217
RNG_SEED_MAGIC2 = 21263

; Seed the RNG with value in a
rngSeed:
            pha
            and #RNG_SEED_MAGIC1
            clc
            adc #lo(RNG_SEED_MAGIC2)
            sta rngA1
            pla
            and #255-RNG_SEED_MAGIC1
            adc #hi(RNG_SEED_MAGIC2)
            sta rngB1
            rts

; Generate next random number, returned in a
rngNext:
rngB1 = _+1
            lda #31
            asl
rngA1 = _+1
            eor #53
            sta rngB1
            adc rngA1
            sta rngA1
            rts
