; StableRaster.asm
; Double IRQ stable raster
; (c) Morten Perriard 2026

; can't be around bad lines
RASTER_LINE = 53

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
			@ldax(RASTER_LINE)
			jsr setRasterCounter
   
   			; set irq vector
            @ldax(irq)
            @stax(INTERRUPT_VECTOR_IRQ) 

			; acknowledge raster interrupt
			dec VIC_INTERRUPT_REGISTER
			
            ; acknowledge timer interrupts
            bit CIA1_INTERRUPT
            bit CIA2_INTERRUPT
            
            cli
 _0:
            ; just some instructions taking different amount of cycles
            nop
            bit $ea
            jmp _0
 
irq:
            @storeRegisters(_restore)
 
            @ldax(_irq2)
            @stax(INTERRUPT_VECTOR_IRQ)

            ; trigger raster interrupt on next line
            inc VIC_RASTER_COUNTER
            
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER

            ; stack hack
            tsx
            
            ; allow interrupts again
            cli

            ; enough nops for the next raster irq to trigger
            @nop(14)
_irq2:
            ; we interupted the above nops (2 cycles), so we
            ; are now within 1 cycle of stable raster
            
            ; restore stack
            txs
               
            ; wait one line
            ldx #8
            dex
            bne _ - 1
            bit $ea

            lda VIC_RASTER_COUNTER
            cmp VIC_RASTER_COUNTER
            
            ; use +1 cycle when raster counter hasn't changed
            ; (branch takes is 3 cycles, else just 2)
            beq _0
_0:
            ; show some stable color changes
            nop
            lda VIC_BACKGROUND_COLOR0
            ldx #1
            ldy #2
            .repeat "n", 5
            stx VIC_BACKGROUND_COLOR0
            sty VIC_BACKGROUND_COLOR0
            .endr      
            sta VIC_BACKGROUND_COLOR0

            @ldax(irq)
            @stax(INTERRUPT_VECTOR_IRQ)

			; write raster line
			@ldax(RASTER_LINE)
			jsr setRasterCounter

			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER

_restore:   @restoreRegisters()
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
