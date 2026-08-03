; Multiplexer.asm
; General purpose sprite multiplexer
; (c) Morten Perriartd 2026
			
SCREEN 		= $0400

SPRITE_COUNT = 16

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
			
			jsr setupSprites
						
			sei

			lda #$35
			sta CPU_IO_PORT
 
			; enable raster interrupt
			lda #%00000001 
			sta VIC_INTERRUPT_ENABLED

			; write raster line
			@ldax(0)
			jsr setRasterCounter
 
			; set irq vector
			@ldax(irq1)
			@stax(INTERRUPT_VECTOR_IRQ)
			cli
			
_loop:
			jsr debugSprites
			jmp _loop

irq1:
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			; push registers to stack
			inc $d020
			@pushAXY()

			jsr moveSprites
			jsr sortSprites
			
			ldx #0
			stx nextVirtualSpriteIndex
			stx nextHardwareSpriteIndex
_0:
			ldy spriteOrder,x
			ldx nextHardwareSpriteIndex
			
			lda spritePointers,y
			sta SCREEN + VIC_SPRITE_POINTERS_OFFSET,x
			
			lda spriteColors,y
			sta VIC_SPRITE0_COLOR,x
			
			; multiply x*2
			txa
			asl
			tax

			; set sprite position
			lda spritePositionX,y
			sta VIC_SPRITE0_POSITION_X_LO,x
			lda spritePositionY,y
			sta VIC_SPRITE0_POSITION_Y,x

			inc nextVirtualSpriteIndex

			inc nextHardwareSpriteIndex
			ldx nextHardwareSpriteIndex
			cpx #8
			bne _0
			
			lda #0
			sta nextHardwareSpriteIndex

			; calculate raster line just below first hardware sprite
			ldy spriteOrder
			lda spritePositionY,y
			ldx #0
			clc
			adc #VIC_SPRITE_HEIGHT
			bcc _1
			inx		
_1:
			; irq2 at raster line below first hardware sprite 
			jsr setRasterCounter
			@ldax(irq2)
			@stax(INTERRUPT_VECTOR_IRQ)

			; pull registers from stack
			@pullYXA()
			dec $d020
			rti

nextVirtualSpriteIndex:		.byte 0
nextHardwareSpriteIndex:	.byte 0


irq2:
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			; push registers to stack
			dec $d020
			@pushAXY()
_0:
			ldx nextVirtualSpriteIndex

			ldy spriteOrder,x
			
			ldx nextHardwareSpriteIndex
			
			lda spritePointers,y
			sta SCREEN + VIC_SPRITE_POINTERS_OFFSET,x
			
			lda spriteColors,y
			sta VIC_SPRITE0_COLOR,x

			txa
			asl
			tax

			; set sprite position
			lda spritePositionX,y
			sta VIC_SPRITE0_POSITION_X_LO,x			
			lda spritePositionY,y
			sta VIC_SPRITE0_POSITION_Y,x
			
			; next hardware sprite index
			ldx nextHardwareSpriteIndex
			inx
			cpx #8
			bne _1
			ldx #0
_1:
			stx nextHardwareSpriteIndex

			; next virtual sprite index
			inc nextVirtualSpriteIndex
			ldx nextVirtualSpriteIndex
			cpx #SPRITE_COUNT
			bne _2			
			
			; irq1 at raster line zero
			@ldax(0)
			jsr setRasterCounter
			@ldax(irq1)
			@stax(INTERRUPT_VECTOR_IRQ)
			jmp _end

_2:

			; TODO: set raster for next sprite
			lda nextHardwareSpriteIndex
			asl
			tax
			lda VIC_SPRITE0_POSITION_Y,x
			clc
			adc #VIC_SPRITE_HEIGHT
			bcc _3
			inx
_3:
			
			
;			ldx #0
;			lda $d012
;			clc
;			adc #50
_4:
			cmp $d012
			bcs _4
			jmp _0
			;bpl _0
			;jsr setRasterCounter

_end:
			; pull registers from stack
			@pullYXA()
			inc $d020
			rti


setupSprites:
			; unexpanded sprites
			lda #0
			sta VIC_SPRITES_EXPANSION_X
			sta VIC_SPRITES_EXPANSION_Y

			; hires sprites
			sta VIC_SPRITES_MCM_ENABLED

			; sprites over chars
			sta VIC_SPRITES_PRIORITY

			; enabled all sprites
			lda #$ff
			sta VIC_SPRITES_ENABLED
			rts


debugSprites:
			ldx #SPRITE_COUNT-1
_0:
			lda spriteOrder,x
			sta SCREEN+24*40,x
			dex
			bpl _0
			rts


moveSprites:
			ldx _frame			
			ldy #0
_0:
			lda xSinTab,x
			sta spritePositionX,y
			
			lda ySinTab,x
			sta spritePositionY,y
			
			txa
			clc
			adc #256 / SPRITE_COUNT
			tax
			iny
			cpy #SPRITE_COUNT
			bne _0
			
			inc _frame
			rts
_frame:		.byte 0			
			
; simple bubble sort - not optimised
sortSprites:
			lda #0
			sta _swaps
			
			ldx #SPRITE_COUNT-2
_0:
			; compare y-positions of sprite N and N+1
			ldy spriteOrder,x
			lda spritePositionY,y
			ldy spriteOrder+1,x
			cmp spritePositionY,y
			
			; less or equal
			bcc _noSwap
			beq _noSwap

			; swap the order (sprites with lower y-position are first)
			ldy spriteOrder,x
			lda spriteOrder+1,x
			sta spriteOrder,x
			tya
			sta spriteOrder+1,x
			inc _swaps
_noSwap:
			dex
			bpl _0

			; we are done when theres no swaps
			lda _swaps
			bne sortSprites
			rts
_swaps:		.byte 0

	
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


; virtual sprite registers
spritePositionX:	.bytefill SPRITE_COUNT
spritePositionY:	.bytefill SPRITE_COUNT
spritePointers:		.bytefill SPRITE_COUNT, "i: [vicSpritePointer(spriteImage1), vicSpritePointer(spriteImage2)][i&1]"
spriteColors:		.bytefill SPRITE_COUNT, "i: [1, 2][i&1]"
spriteOrder:		.bytefill SPRITE_COUNT, "i: i"

			.align 256
xSinTab:	.bytefill 256, "a: round(139.5 + 115.5 * cos(2*pi * a / 256))"

			.align 256
ySinTab:	.bytefill 256, "a: round(139.5 + 89.5 * sin(2*pi * a / 256))"

			.align VIC_SPRITE_MEMORY_ALIGNMENT
spriteImage1:		
			.bits "########################"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "#                      #"
			.bits "########################"


			.align VIC_SPRITE_MEMORY_ALIGNMENT
spriteImage2:
			.bits "########################"
			.bits "#                      #"
			.bits "# #################### #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #                  # #"
			.bits "# #################### #"
			.bits "#                      #"
			.bits "########################"


