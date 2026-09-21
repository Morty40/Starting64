; ScaleFontX2.asm
; Scale font X2
; (c) Morten Perriard 2026

SCREEN_ADDRESS	= $0400
FONT_ADDRESS	= $2000

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
			@basicEnd()
start:
			cld
			sei
			
			; clear screen
			jsr $e544
			
			; point to 2x scaled font
			lda #vicScreenAndCharsetPointer(SCREEN_ADDRESS, FONT_ADDRESS)
			sta VIC_MEMORY_POINTERS

			jsr printText

			; access to char rom								
			lda #$32 
			sta CPU_IO_PORT
			
			; x-scale 64 first chars of font to a 2x1 char font
			lda #hi(CHAR_ROM)
			ldx #hi(FONT_ADDRESS)
			jsr scaleLeft
			lda #hi(CHAR_ROM)+1
			ldx #hi(FONT_ADDRESS)+1
			jsr scaleLeft
			lda #hi(CHAR_ROM)
			ldx #hi(FONT_ADDRESS)+2
			jsr scaleRight
			lda #hi(CHAR_ROM)+1
			ldx #hi(FONT_ADDRESS)+3
			jsr scaleRight
			
			; y-scale 128 first chars of font to a 2x2 char font
			lda #4
			ldx #hi(FONT_ADDRESS)
			ldy #hi(FONT_ADDRESS)+4
_0:
			@storeRegisters(_r0)
			jsr scaleVertically
_r0:		@restoreRegisters()
			inx
			iny
			cpx #hi(FONT_ADDRESS)+4
			bne _0
			
			lda #0
			ldx #hi(FONT_ADDRESS)
			ldy #hi(FONT_ADDRESS)
_1:
			@storeRegisters(_r1)
			jsr scaleVertically
_r1:		@restoreRegisters()
			inx
			iny
			cpx #hi(FONT_ADDRESS)+4
			bne _1
					
			jmp _

scaleLeft:
			sta _0+2
			stx _1+2
			ldy #0
_0:
			lda $ff00,y
			and #$f0
			lsr
			lsr
			lsr
			lsr
			tax
			lda bitsX2,x
_1:		
			sta $ff00,y
			iny
			bne _0
			rts
			
scaleRight:
			sta _0+2
			stx _1+2
			ldy #0
_0:
			lda $ff00,y
			and #$0f
			tax
			lda bitsX2,x
_1:		
			sta $ff00,y
			iny
			bne _0
			rts

bitsX2:		.byte %00000000, %00000011, %00001100, %00001111
			.byte %00110000, %00110011, %00111100, %00111111
			.byte %11000000, %11000011, %11001100, %11001111
			.byte %11110000, %11110011, %11111100, %11111111

scaleVertically:
			sta _1+1
			stx _1+2
			sty _2+2
_3:
			ldy #7
_0:			
			; x = y/2
			tya
			lsr
			tax
_1:			lda $ff00,x
_2:			sta $ff00,y
			dey
			bpl _0
			
			lda _1+1
			clc
			adc #8
			sta _1+1
			
			lda _2+1
			clc
			adc #8
			sta _2+1
			bne _3
			rts

printText:
			ldx #0
_0:
			txa
			asl
			tay
			txa
			
			sta SCREEN_ADDRESS,y
			eor #$40
			sta SCREEN_ADDRESS+1,y
			eor #$c0
			sta SCREEN_ADDRESS+40,y
			eor #$40
			sta SCREEN_ADDRESS+41,y
			inx
			cpx #20
			bne _0		
			rts
