
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: Colors.prg

vice: all
	x64sc -autostartprgmode 1 -autostart ~mp/GitHub/Starting64/Colors/Colors.prg

run: all
	curl -F 'data=@./Colors.prg' 172.20.10.3/v1/runners:run_prg
