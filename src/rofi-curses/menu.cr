require "../ncurses/window"

module Rofi::Curses
  class Menu
    getter search, list

    def initialize(@items : Array, height = nil, width = nil, y = 0, x = 0)
      max_height, max_width = NCurses.stdscr.max_dimensions
      @search = NCurses::Window.new(1, width, y, x)
      @list = NCurses::Window.new((height || max_height) - 1, width, y + 1, x)
      @query = [] of Char
      @cursor = 0
      @filter_chain = [@items.map_with_index { |item, index| { item, index } }]
    end

    def filter_items
      @filter_chain.push(filtered_items.clone)
      tokens = @query.join.split(/\s+/).map { |token| /#{Regex.escape(token)}/i }

      index = 0
      filtered_items.select! do |item_with_index|
        item, real_index = item_with_index
        match = tokens.all? { |token| item =~ token }
        @cursor = 0 if !match && @cursor == index
        index += 1
        match
      end
    end

    def on_input
      loop do
        search.no_timeout
        char = search.get_char
        case(char)
        when 27
          search.no_delay
          char = search.get_char
          if char == -1
            yield(:escape)
          elsif char == 91
            case(search.get_char)
            when 65 then yield(:up)
            when 66 then yield(:down)
            end
          else
            yield(char.chr, :alt)
          end
        when 10
          yield(:return)
        when 32..127
          yield(char.chr)
        end
      end
    end

    def filtered_items
      @filter_chain.last
    end

    def type_and_filter(char)
      if char == 127.chr
        return if @query.empty?
        @query.pop
        @search.clear
        @search.print(@query.join)
        @filter_chain.pop
      else
        @query << char
        @search.print(char.to_s)
        filter_items
      end

      refresh_list
    end

    def move_cursor(offset)
      return unless 0 <= @cursor + offset < filtered_items.size
      @cursor += offset
      refresh_list
    end

    def show
      refresh_list

      on_input do |char, modifier|
        if modifier == :alt
          return { filtered_items[@cursor]?.try { |item| item[0] }, char }
        end
        case(char)
        when :escape then return { nil, nil }
        when :return then return { filtered_items[@cursor]?.try { |item| item[0] }, nil }
        when :up then move_cursor(-1)
        when :down then move_cursor(1)
        else type_and_filter(char as Char)
        end
      end
    end

    def refresh_list
      @list.clear
      height, _ = @list.max_dimensions
      start_index = [0, (@cursor + 1) - height].max
      end_index = [start_index + height, filtered_items.size].min
      `notify-send #{filtered_items.size}`
      filtered_items[start_index...end_index].each_with_index do |item_with_index, index|
        item, real_index = item_with_index
        attributes = (start_index + index) == @cursor ? :standout : :normal
        @list.with_attr(attributes) do
          @list.print(item.to_s, { index, 0 })
        end
      end
      @list.refresh
    end
  end
end
