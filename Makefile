release:
	crystal build --release -o bin/rofi-curses src/rofi-curses-cli.cr

debug:
	crystal build -d -o bin/rofi-curses src/rofi-curses-cli.cr

test:
	crystal spec

install: release
	install bin/rofi-curses -Dm755 bin/rofi-curses /usr/bin/crystal
