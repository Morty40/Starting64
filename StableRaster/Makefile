
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: StableRaster.prg

vice: all
	x64sc -autostartprgmode 1 -autostart StableRaster.prg
