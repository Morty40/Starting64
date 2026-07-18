; Joystick.asm
; Read joystick input
; (c) Morten Perriartd 2026

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
			@basicEnd()
			
SCREEN		= $0400
			
start:
			; set port A and B to input (read only)
			lda #0
			sta CIA1_DATA_DIRECTION_PORTA
			sta CIA1_DATA_DIRECTION_PORTB
_0:
			; read joystick in port 1 and write to screen
			jsr joystickReadPort1
			
			; write a, x, y to screen
			clc
			adc #ord('+')
			sta SCREEN + 0
			inx
			lda _dxText,x
			sta SCREEN + 1
			iny
			lda _dyText,y
			sta SCREEN + 2
						
			; read joystick in port 2 and write to screen
			jsr joystickReadPort2

			; write a, x, y to screen
			clc
			adc #ord('+')
			sta SCREEN + 4
			inx
			lda _dxText,x
			sta SCREEN + 5
			iny
			lda _dyText,y
			sta SCREEN + 6

			; loop			
			jmp _0

			.encoding ENCODING_SCREEN_UPPER
_dxText:	.text "L+R"
_dyText:	.text "U+D"

; Read joystick in port 1 or 2
; Return:
; a: fire button state
; x: left/right state [-1, 0, 1]
; y: up/down state [-1, 0, 1]
joystickReadPort1:
			lda CIA1_DATA_PORTB
			jmp joystickDecode
joystickReadPort2:
			lda CIA1_DATA_PORTA
joystickDecode:
			ldx #0
			ldy #0
			lsr
			bcs _0
			dey
_0:			lsr
			bcs _1
			iny
_1:			lsr
			bcs _2
			dex
_2:			lsr
			bcs _3
			inx
_3:			lsr
			lda #$ff
			adc #0
			rts

			