release:
	crystal build --release -o bin/rofi-curses src/rofi-curses.cr

debug:
	crystal build -d -o bin/rofi-curses src/rofi-curses.cr

test:
	crystal spec spec/rofi-curses_spec.cr
