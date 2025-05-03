
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Sprites.prg

run: all
	x64sc -autostartprgmode 1 -autostart ~mp/GitHub/Starting64/Sprites/Sprites.prg
