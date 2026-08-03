
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Multiplexer.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Multiplexer.prg
