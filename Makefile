release: deps
	crystal build --release -o bin/rofi-curses src/rofi-curses-cli.cr

deps:
	shards install

debug: deps
	crystal build -d -o bin/rofi-curses src/rofi-curses-cli.cr

test: deps
	crystal spec

install: release
	install bin/rofi-curses -Dm755 bin/rofi-curses /usr/bin/crystal
