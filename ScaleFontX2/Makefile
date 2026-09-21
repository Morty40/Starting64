
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: ScaleFontX2.prg

vice: all
	x64sc -autostartprgmode 1 -autostart ScaleFontX2.prg
