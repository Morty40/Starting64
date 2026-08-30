; CharScroll.asm
; Simple char scroll
; (c) Morten Perriard 2026

SCREEN		= $0400

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
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
			RASTER_LINE = 50 + 8*CHARSCROLL_ROW
			@ldax(RASTER_LINE)
			jsr setRasterCounter
 
			; set irq vector
			@ldax(irq1)
			@stax(INTERRUPT_VECTOR_IRQ)
			
			cli
			jmp _ ; infinite loop

irq1:
			@pushRegisters()

			; wait for right border
			@nop(18)
			
			lda charScrollX
			sta VIC_CONTROL_SCROLL_X

			@ldax(RASTER_LINE+8)
			jsr setRasterCounter
			
			; set irq vector
			@ldax(irq2)
			@stax(INTERRUPT_VECTOR_IRQ)

			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			@pullRegisters()			
			rti

irq2:
			@pushRegisters()

			; wait for right border
			@nop(18)

			; back to 40 columns mode
			lda #8
			sta VIC_CONTROL_SCROLL_X

			jsr charScroll
			
			@ldax(RASTER_LINE)
			jsr setRasterCounter

			; set irq vector
			@ldax(irq1)
			@stax(INTERRUPT_VECTOR_IRQ)

			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			@pullRegisters()			
			rti

CHARSCROLL_SPEED	= 1
CHARSCROLL_ROW		= 24

charScroll:
			lda charScrollX
			sec
			sbc #CHARSCROLL_SPEED
			and #7
			sta charScrollX
			bcs _0
			
			; move one row of chars
			ldx #0
_1:
			lda SCREEN + VIC_CHAR_COLUMNS*CHARSCROLL_ROW + 1,x
			sta SCREEN + VIC_CHAR_COLUMNS*CHARSCROLL_ROW,x
			inx
			cpx #VIC_CHAR_COLUMNS - 1
			bne _1

			; new char appearing on the right side
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
			; put next char on screen
			sta SCREEN + VIC_CHAR_COLUMNS * CHARSCROLL_ROW + VIC_CHAR_COLUMNS - 1	

			; increment text pointer
			inc _readText+1
			bne _0
			inc _readText+2
_0:
			rts
			.encoding ENCODING_SCREEN_UPPER
_text:		.text "HELLO WORLD 1234567890 "
			.byte 0
charScrollX:.byte 0
			
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
