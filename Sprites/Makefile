
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Sprites.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Sprites.prg
