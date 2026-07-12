
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Joystick.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Joystick.prg

run: all
	curl -F 'data=@./Joystick.prg' 172.20.10.3/v1/runners:run_prg
