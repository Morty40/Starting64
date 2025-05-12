
			; BASIC start
			@basicStart()
			@basicSys(2025, start)
			@basicEnd()
start:
			cld

			; disable CIA interrupts
			lda #$7f
			sta CIA1_INTERRUPT
			sta CIA2_INTERRUPT
			sei

			lda #$35
			sta CPU_IO_PORT
 
			; enable raster interrupt
			lda #%00000001 
			sta VIC_INTERRUPT_ENABLED

			; write raster line
			RASTER_LINE = 260
			lda #lo(RASTER_LINE)
			ldx #hi(RASTER_LINE)
			jsr setRasterCounter
 
			; set irq vector
			lda #lo(irq1)
			sta INTERRUPT_VECTOR_IRQ_LO
			lda #hi(irq1)
			sta INTERRUPT_VECTOR_IRQ_HI
			cli
			jmp _ ; infinite loop

irq1:
			dec VIC_INTERRUPT_REGISTER ; acknowledge interrupt
			@pushAXY()

			jsr bigScroll
			
			@pullYXA()
			rti

BIG_SCROLL_SCREEN = $0400 + 5*VIC_CHAR_COLUMNS
bigScroll:
			; rotate bitmask right, bit 0 into carry
			lsr _bit 
			bcc _moveAndDraw
			lda #$80 ; reset to bit7 left column
			sta _bit
_readText:			
			lda _text
			bne _notEndOfText

			; reset pointer to start of text
			lda #lo(_text)
			sta _readText+1
			lda #hi(_text)
			sta _readText+2
			lda _text ; and read first char
_notEndOfText:
			; char is in A, mult x8 to get pointer
			ldx #hi(CHAR_ROM)
			stx _readRom+2
			ldy #2
_mult8:
			clc
			asl
			bcc _8
			inc _readRom+2
_8:
			dey
			bpl _mult8
			sta _readRom+1

			lda CPU_IO_PORT
			sta _restore1+1
			lda #$32 ; temp access to char rom
			sta CPU_IO_PORT

			; copy 8 bytes of char data from ROM
			ldy #7
_readRom:
			lda $ffff,y
			sta _char,y
			dey
			bpl _readRom
_restore1:
			lda #$ff
			sta CPU_IO_PORT

			; increment text pointer
			inc _readText+1
			bne _0
			inc _readText+2
_0:
_moveAndDraw:
			; move 8 char rows left
			ldx #0
_m:
			.repeat 'y', 8
			lda BIG_SCROLL_SCREEN + VIC_CHAR_COLUMNS*y + 1,x
			sta BIG_SCROLL_SCREEN + VIC_CHAR_COLUMNS*y,x
			.endr
			inx
			cpx #VIC_CHAR_COLUMNS - 1
			bne _m

			; after rows have moved left, draw right most column
			.repeat 'y', 8
			ldx #0
			lda _char+y
			and _bit
			beq _+3
			inx
			lda _gfx,x
			sta BIG_SCROLL_SCREEN + VIC_CHAR_COLUMNS*y + VIC_CHAR_COLUMNS-1
			.endr
			rts
			
			.encoding ENCODING_SCREEN_UPPER
_text:		.text "HELLO WORLD 1234567890 "
			.byte 0
_bit:		.byte 1
_gfx:		.text " O"
_char:		.bytefill 8

; set raster counter value, ($d012, and hi-bit $d011)
; a = lo(rasterline)
; x = hi(rasterline)
; where rasterline is a 9-bit value
setRasterCounter:
			sta VIC_RASTER_COUNTER
			lda VIC_CONTROL_SCROLL_Y
			and #%01111111
			cpx #0
			beq _0
			ora #%10000000
_0:
			sta VIC_CONTROL_SCROLL_Y
			rts
