require "option_parser"
require "./ncurses"
require "./rofi-curses/*"

module Rofi::Curses
  module Cli
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

      parser.on("-v", "--version", "Show version") do
        puts Rofi::Curses::VERSION
        exit
      end
    end

    while item = input.gets
      items << item.chomp
    end

    input.close
    STDIN.reopen(File.open("/dev/tty"))

    NCurses.init
    NCurses.raw
    NCurses.no_echo

    menu = Menu.new(items, prompt: prompt)

    choice, modifier = menu.show
    NCurses.end_win

    puts "#{choice}"
  end
end
