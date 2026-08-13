; Multiplexer.asm
; General purpose sprite multiplexer
; (c) Morten Perriard 2026
			
SCREEN 		= $0400

SPRITE_COUNT = 32

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
			
			; loop
			jmp _

irq1:
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			; push registers to stack
			;inc $d020
			@pushAXY()

			; setup virtual sprite positions and sort by y
			jsr moveSprites
			jsr sortSprites
			
			; reset sprite indices
			ldx #0
			stx nextVirtualSprite
			stx nextHardwareSprite
			
			; do the first 8 sprites, no multiplexing yet
_0:
			jsr updateNextSprite
			; (updates nextHardwareSprite)
			
			; increment nextVirtualSprite
			inc nextVirtualSprite
			lda nextVirtualSprite
			cmp #SPRITE_COUNT
			beq _2
			
			; when nextHardwareSprite wraps around to zero, all hw sprites are used
			lda nextHardwareSprite
			bne _0

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
_2:
			; pull registers from stack
			@pullYXA()
			;dec $d020
			rti

			.zpbyte "nextVirtualSprite"
			.zpbyte "nextHardwareSprite"


irq2:
			; acknowledge interrupt
			dec VIC_INTERRUPT_REGISTER
			
			; push registers to stack
			;inc $d020
			@pushAXY()
_0:
			jsr updateNextSprite
			
			; next virtual sprite index
			inc nextVirtualSprite
			ldx nextVirtualSprite
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
			lda nextHardwareSprite
			asl
			tax
			lda VIC_SPRITE0_POSITION_Y,x
			clc
			adc #VIC_SPRITE_HEIGHT

			cmp VIC_RASTER_COUNTER
			beq _0
			bcc _0
			sta VIC_RASTER_COUNTER
_end:
			; pull registers from stack
			@pullYXA()
			;dec $d020
			rti


updateNextSprite:
			; x = hardware sprite index
			; y = virtual sprite index
			ldx nextVirtualSprite
			ldy spriteOrder,x
			ldx nextHardwareSprite

			; set sprite image pointer			
			lda spritePointers,y
			sta SCREEN + VIC_SPRITE_POINTERS_OFFSET,x
			
			; set sprite color
			lda spriteColors,y
			sta VIC_SPRITE0_COLOR,x

			; set sprint x-position hi bit
			lda VIC_SPRITES_POSITION_X_HI
			and _mask,x
			sta VIC_SPRITES_POSITION_X_HI
			lda spritePositionXHi,y
			beq _0
			lda VIC_SPRITES_POSITION_X_HI
			ora _bit,x
			sta VIC_SPRITES_POSITION_X_HI
_0:
			; multiply x*2
			txa
			asl
			tax

			; set sprite x, y position
			lda spritePositionXLo,y
			sta VIC_SPRITE0_POSITION_X_LO,x			
			lda spritePositionY,y
			sta VIC_SPRITE0_POSITION_Y,x
			
			; advance to next hardware sprite
			lda nextHardwareSprite
			clc
			adc #1
			and #7
			sta nextHardwareSprite
			rts
_mask:		.byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
_bit:		.byte $01, $02, $04, $08, $10, $20, $40, $80


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


moveSprites:
			ldx _frame			
			ldy #0
_0:
			lda xSinTabLo,x
			sta spritePositionXLo,y

			lda xSinTabHi,x
			sta spritePositionXHi,y
			
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
			; elements are in order when theres no swaps
_noSwap:
			dex
			bpl _0
			
			; uncomment this to do another pass until 100% sorted
			;lda _swaps
			;bne sortSprites
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
spritePositionXLo:	.bytefill SPRITE_COUNT
spritePositionXHi:	.bytefill SPRITE_COUNT
spritePositionY:	.bytefill SPRITE_COUNT
spritePointers:		.bytefill SPRITE_COUNT, "i: [vicSpritePointer(spriteImage1), vicSpritePointer(spriteImage2)][i&1]"
spriteColors:		.bytefill SPRITE_COUNT, "i: [1, 2][i&1]"
spriteOrder:		.bytefill SPRITE_COUNT, "i: i"

			.align 256
xSinTabLo:	.bytefill 256, "a: lo(round(148+24 + 148 * cos(2*pi * a / 256)))"
xSinTabHi:	.bytefill 256, "a: hi(round(148+24 + 148 * cos(2*pi * a / 256)))"

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


