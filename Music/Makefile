
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Music.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Music.prg
