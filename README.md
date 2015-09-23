# rofi-curses ![travis ci](https://travis-ci.org/jreinert/rofi-curses.svg?branch=master)

This aims to be a clone of rofi providing compatibility for (almost) all
command line switches and general functionality. It runs completely in the
console so you can use it on a headless server.

rofi-curses is written in [Crystal](http://crystal-lang.org). It aims to
provide extremely fast filtering and already does a pretty good job at that.

## Installation

1. Get [Crystal](http://crystal-lang.org)
2. `git clone https://github.com/jreinert/rofi-curses.git`
3. `cd rofi-curses`
4. `make && make install`

## Usage

`echo -n "foo\nbar\nbaz" | rofi-curses -p Choose:`
`rofi-curses -p 'Lines in file:' -f path/to/a/file`

## Contributing

1. Fork it ( https://github.com/jreinert/rofi-curses/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jreinert](https://github.com/jreinert) Joakim Reinert - creator, maintainer
