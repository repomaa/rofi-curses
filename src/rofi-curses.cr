require "./rofi-curses/*"

module Rofi::Curses
  items = [] of String

  while item = STDIN.gets
    items << item.chomp
  end

  stdout = File.open("/dev/null")
  stdout.reopen(STDOUT)
  STDIN.reopen(File.open("/dev/tty"))
  STDOUT.reopen(STDERR)

  NCurses.init
  NCurses.raw
  NCurses.no_echo

  menu = Menu.new(items)

  choice, modifier = menu.show
  NCurses.end_win

  STDOUT.reopen(stdout)
  puts "#{choice}"
end
