
SCREEN 		= $0400

			; BASIC start
			@basicStart()
			@basicSys(0, start)
			@basicEnd()
start:
			; set sprite colors, pointers
			ldx #7
_0:
			lda _colors,x
			sta VIC_SPRITE0_COLOR,x			
			lda #vicSpritePointer(_image)
			sta SCREEN + VIC_SPRITE_POINTERS_OFFSET,x
			dex
			bpl _0

			; position sprites
			ldx #0
			ldy #0
			stx VIC_SPRITES_POSITION_X_HI
_1:
			lda _xpos,y
			sta VIC_SPRITE0_POSITION_X_LO,y
			
			lda _xpos+1,y
			beq _2
			lda _bits,x
			ora VIC_SPRITES_POSITION_X_HI
			sta VIC_SPRITES_POSITION_X_HI
_2:			
			lda _ypos,x
			sta VIC_SPRITE0_POSITION_Y,y
			iny
			iny
			inx
			cpx #8
			bne _1
	
			; make sprites unexpanded hires
			lda #0
			sta VIC_SPRITES_EXPANSION_X
			sta VIC_SPRITES_EXPANSION_Y
			sta VIC_SPRITES_MCM_ENABLED

			; enabled all sprites
			lda #$ff
			sta VIC_SPRITES_ENABLED			
			rts

_bits:		.byte 1, 2, 4, 8, 16, 32, 64, 128
			
_colors: 	.byte VIC_COLOR_RED, VIC_COLOR_WHITE, VIC_COLOR_RED, VIC_COLOR_WHITE
			.byte VIC_COLOR_RED, VIC_COLOR_WHITE, VIC_COLOR_RED, VIC_COLOR_WHITE

_xpos:		.word 60, 90, 120, 150, 180, 210, 240, 270			 
_ypos:		.byte 60, 80, 100, 120, 140, 160, 180, 200
 
			.align 64
_image:		
			.bits "111111111111111111111111"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "1                      1"
			.bits "111111111111111111111111"
