; Font.asm
; Set a custom font
; (c) Morten Perriartd 2026

SCREEN_ADDRESS	= $0400
FONT_ADDRESS	= $2000

			; BASIC start
			@basicStart()
			@basicSys(2026, start)
			@basicEnd()
start:
			lda #vicScreenAndCharsetPointer(SCREEN_ADDRESS, FONT_ADDRESS)
			sta VIC_MEMORY_POINTERS
			rts

; Custom font definition
.org FONT_ADDRESS

.bits " #####  " ; @
.bits "##   ## "
.bits "## #### "
.bits "## # ## "
.bits "## ###  "
.bits "##      "
.bits " #####  "
.bits "        "

.bits "  ###   " ; A
.bits " ## ##  "
.bits "##   ## "
.bits "####### "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits "######  " ; B
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "        "

.bits " #####  " ; C
.bits "##   ## "
.bits "##      "
.bits "##      "
.bits "##      "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "######  " ; D
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "        "

.bits "####### " ; E
.bits "##      "
.bits "##      "
.bits "####    "
.bits "##      "
.bits "##      "
.bits "####### "
.bits "        "

.bits "####### " ; F
.bits "##      "
.bits "##      "
.bits "#####   "
.bits "##      "
.bits "##      "
.bits "##      "
.bits "        "

.bits " #####  " ; G
.bits "##      "
.bits "##      "
.bits "##  ### "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "##   ## " ; H
.bits "##   ## "
.bits "##   ## "
.bits "####### "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits "######  " ; I
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "####### "
.bits "        "

.bits "  ##### " ; J
.bits "     ## "
.bits "     ## "
.bits "     ## "
.bits "     ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "##   ## " ; K
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits "##      " ; L
.bits "##      "
.bits "##      "
.bits "##      "
.bits "##      "
.bits "##      "
.bits "####### "
.bits "        "

.bits "##   ## " ; M
.bits "### ### "
.bits "####### "
.bits "## # ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits "##   ## " ; N
.bits "###  ## "
.bits "#### ## "
.bits "## #### "
.bits "##  ### "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits " #####  " ; O
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "######  " ; P
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "##      "
.bits "##      "
.bits "##      "
.bits "        "

.bits " #####  " ; Q
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##  ##  "
.bits " ### ## "
.bits "        "

.bits "######  " ; R
.bits "##   ## "
.bits "##   ## "
.bits "######  "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits " #####  " ; S
.bits "##   ## "
.bits "##      "
.bits " #####  "
.bits "     ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "####### " ; T
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "        "

.bits "##   ## " ; U
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "##   ## " ; V
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits " ## ##  "
.bits "  ###   "
.bits "        "

.bits "##   ## " ; W
.bits "##   ## "
.bits "##   ## "
.bits "## # ## "
.bits "####### "
.bits "### ### "
.bits "##   ## "
.bits "        "

.bits "##   ## " ; X
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits "        "

.bits "##   ## " ; Y
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "        "

.bits "####### " ; Z
.bits "    ##  "
.bits "   ##   "
.bits "  ##    "
.bits " ##     "
.bits "##      "
.bits "####### "
.bits "        "

.bits "  ##### " ; [
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##### "
.bits "        "

.bits " ## ##  " ; (pound)
.bits "####### "
.bits "####### "
.bits "####### "
.bits " #####  "
.bits "  ###   "
.bits "   #    "
.bits "        "

.bits "#####   " ; ]
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "#####   "
.bits "        "

.bits "        " ; (arrow up)
.bits "        "
.bits "   #    "
.bits "  ###   "
.bits " #####  "
.bits "####### "
.bits "        "
.bits "        "

.bits "        " ; (arrow left)
.bits "        "
.bits "####### "
.bits " #####  "
.bits "  ###   "
.bits "   #    "
.bits "        "
.bits "        "

.bits "        " ; (space)
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "

.bits "  ##    " ; !
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "  ##    "
.bits "        "
.bits "  ##    "
.bits "        "

.bits " ##  ## " ; "
.bits " ##  ## "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "

.bits "        " ; #
.bits " ##  ## "
.bits "####### "
.bits " ##  ## "
.bits "####### "
.bits " ##  ## "
.bits "        "
.bits "        "

.bits " #####  " ; $
.bits "## # ## "
.bits "## #    "
.bits " #####  "
.bits "   # ## "
.bits "## # ## "
.bits " #####  "
.bits "        "

.bits "        " ; %
.bits "##   ## "
.bits "##  ##  "
.bits "   ##   "
.bits "  ##    "
.bits " ##  ## "
.bits "##   ## "
.bits "        "

.bits " #####  " ; &
.bits "##      "
.bits " ##     "
.bits "#### ## "
.bits "## ###  "
.bits "##  ##  "
.bits " ### ## "
.bits "        "

.bits "   ##   " ; '
.bits "  ##    "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "

.bits "   ###  " ; (
.bits "  ##    "
.bits " ##     "
.bits " ##     "
.bits " ##     "
.bits "  ##    "
.bits "   ###  "
.bits "        "

.bits " ###    " ; )
.bits "   ##   "
.bits "    ##  "
.bits "    ##  "
.bits "    ##  "
.bits "   ##   "
.bits " ###    "
.bits "        "

.bits "        " ; *
.bits " ## ##  "
.bits "  ###   "
.bits "####### "
.bits "  ###   "
.bits " ## ##  "
.bits "        "
.bits "        "

.bits "        " ; +
.bits "   ##   "
.bits "   ##   "
.bits " ###### "
.bits "   ##   "
.bits "   ##   "
.bits "        "
.bits "        "

.bits "        " ; ,
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "   ##   "
.bits "  ##    "

.bits "        " ; -
.bits "        "
.bits "        "
.bits " ###### "
.bits "        "
.bits "        "
.bits "        "
.bits "        "

.bits "        " ; .
.bits "        "
.bits "        "
.bits "        "
.bits "        "
.bits "   ##   "
.bits "   ##   "
.bits "        "

.bits "        " ; /
.bits "     ## "
.bits "    ##  "
.bits "   ##   "
.bits "  ##    "
.bits " ##     "
.bits "##      "
.bits "        "

.bits " #####  " ; 0
.bits "##   ## "
.bits "##   ## "
.bits "## # ## "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "   ##   " ; 1
.bits " ####   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "####### "
.bits "        "

.bits " #####  " ; 2
.bits "##   ## "
.bits "     ## "
.bits " #####  "
.bits "##      "
.bits "##      "
.bits "####### "
.bits "        "

.bits " #####  " ; 3
.bits "##   ## "
.bits "     ## "
.bits "   ###  "
.bits "     ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "  ##    " ; 4
.bits " ##  ## "
.bits "##   ## "
.bits "##   ## "
.bits "####### "
.bits "     ## "
.bits "     ## "
.bits "        "

.bits "######  " ; 5
.bits "##      "
.bits "######  "
.bits "     ## "
.bits "     ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits " #####  " ; 6
.bits "##      "
.bits "######  "
.bits "##   ## "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits "####### " ; 7
.bits "     ## "
.bits "    ##  "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "   ##   "
.bits "        "

.bits " #####  " ; 8
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "##   ## "
.bits "##   ## "
.bits " #####  "
.bits "        "

.bits " #####  " ; 9
.bits "##   ## "
.bits "##   ## "
.bits " ###### "
.bits "     ## "
.bits "     ## "
.bits " #####  "
.bits "        "

.bits "        " ; :
.bits "  ##    "
.bits "  ##    "
.bits "        "
.bits "  ##    "
.bits "  ##    "
.bits "        "
.bits "        "

.bits "        " ; ;
.bits "  ##    "
.bits "  ##    "
.bits "        "
.bits "  ##    "
.bits " ##     "
.bits "        "
.bits "        "

.bits "        " ; <
.bits "    ### "
.bits "  ###   "
.bits "###     "
.bits "  ###   "
.bits "    ### "
.bits "        "
.bits "        "

.bits "        " ; =
.bits "        "
.bits " #####  "
.bits "        "
.bits " #####  "
.bits "        "
.bits "        "
.bits "        "

.bits "        " ; >
.bits "###     "
.bits "  ###   "
.bits "    ### "
.bits "  ###   "
.bits "###     "
.bits "        "
.bits "        "

.bits " #####  " ; ?
.bits "##   ## "
.bits "     ## "
.bits "   ###  "
.bits "  ##    "
.bits "        "
.bits "  ##    "
.bits "        "
