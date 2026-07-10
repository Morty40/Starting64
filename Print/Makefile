
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Print.prg

vice: all
	x64sc -autostartprgmode 1 -autostart Print.prg

run: all
	curl -F 'data=@./Print.prg' 172.20.10.3/v1/runners:run_prg
