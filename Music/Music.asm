; Music.asm
; Import music from .sid file and play
; (c) Morten Perriartd 2026

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
			
			; music init
			lda #0
			jsr TRACK1_INIT

			sei

			lda #$35
			sta CPU_IO_PORT
 
			; enable raster interrupt
			lda #%00000001 
			sta VIC_INTERRUPT_ENABLED

			; write raster line
			@ldax(100)
			jsr setRasterCounter
 
			; set irq vector
			lda #lo(irq1)
			sta INTERRUPT_VECTOR_IRQ_LO
			lda #hi(irq1)
			sta INTERRUPT_VECTOR_IRQ_HI
			cli
			
			jmp _ ; infinite loop

irq1:
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			; push registers to stack
			@pushAXY()

			; music play
			inc VIC_BORDER_COLOR
			jsr TRACK1_PLAY
			dec VIC_BORDER_COLOR
						
			; pull registers from stack
			@pullYXA()
			rti

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

			; .music will define:
			; TRACK1_LOAD, TRACK1_INIT, TRACK1_PLAY
			_ = TRACK1_LOAD
			.music "track1.sid", "TRACK1"
