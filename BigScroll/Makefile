
%.prg: %.asm
	code64 -a $< -o $@

clean:
	rm -f *.prg

all: BigScroll.prg

vice: all
	x64sc -autostartprgmode 1 -autostart BigScroll.prg

run: all
	curl -F 'data=@./BigScroll.prg' 172.20.10.3/v1/runners:run_prg
