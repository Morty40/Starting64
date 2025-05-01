
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Colors.prg

run: all
	x64sc -autostartprgmode 1 -autostart ~mp/GitHub/Starting64/Colors/Colors.prg
