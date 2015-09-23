require "./rofi-curses/*"
require "option_parser"

module Rofi::Curses
  items = [] of String

  prompt = ""
  input = STDIN

  OptionParser.parse! do |parser|
    parser.on("-pPROMPT", "--prompt PROMPT", "The prompt to show") do |value|
      prompt = "#{value.strip} "
    end
    parser.on("-fFILE", "--file FILE", "Show lines from file") do |value|
      input = File.open(value)
    end
  end

  while item = input.gets
    items << item.chomp
  end

  input.close

  stdout = File.open("/dev/null")
  stdout.reopen(STDOUT)
  STDIN.reopen(File.open("/dev/tty"))
  STDOUT.reopen(STDERR)

  NCurses.init
  NCurses.raw
  NCurses.no_echo

  menu = Menu.new(items, prompt: prompt)

  choice, modifier = menu.show
  NCurses.end_win

  STDOUT.reopen(stdout)
  puts "#{choice}"
end
