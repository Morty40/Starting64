
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Font.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Font.prg
