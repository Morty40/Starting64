
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: CharScroll.prg

vice: all
	x64sc -autostartprgmode 1 -autostart CharScroll.prg
