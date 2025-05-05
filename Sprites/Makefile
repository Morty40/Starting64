
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Sprites.prg

vice: all
	x64sc -autostartprgmode 1 -autostart ~mp/GitHub/Starting64/Sprites/Sprites.prg

run: all
	curl -F 'data=@./Sprites.prg' 172.20.10.3/v1/runners:run_prg
