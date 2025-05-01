
			; BASIC start
			@basicStart()
			@basicSys(0, start)
			@basicEnd()
start:
			; set border color
			lda #VIC_COLOR_LIGHT_RED
			sta VIC_BORDER_COLOR
			
			; set background color
			lda #VIC_COLOR_RED
			sta VIC_BACKGROUND_COLOR0
			
			rts
