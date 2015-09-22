require "../ncurses"

module NCurses
  class Window
    ATTRIBUTES = [
      :normal, :attributes, :chartext, :color, :standout, :underline, :reverse,
      :blink, :dim, :bold, :altcharset, :invis, :protect, :horizontal, :left,
      :low, :right, :top, :vertical, :italic
    ]

    def initialize(height = nil, width = nil, y = 0, x = 0)
      max_height, max_width = NCurses.stdscr.max_dimensions
      initialize(LibNCurses.newwin(height || max_height, width || max_width, y, x))
    end

    def max_dimensions
      { LibNCurses.getmaxy(self), LibNCurses.getmaxx(self) }
    end

    private macro def attr_mask(*attributes) : LibNCurses::Attribute
      mask = LibNCurses::Attribute::NORMAL

      attributes.each do |attribute|
        mask |= case(attribute)
        {% for attribute in ATTRIBUTES %}
        when {{attribute}} then LibNCurses::Attribute::{{attribute.upcase.id}}
        {% end %}
        else
          raise "unknown attribute #{attribute}"
        end
      end

      mask
    end

    def attr_on(*attributes)
      LibNCurses.wattr_on(self, attr_mask(*attributes), Pointer(Void).null)
    end

    def attr_off(*attributes) 
      LibNCurses.wattr_off(self, attr_mask(*attributes), Pointer(Void).null)
    end

    def with_attr(*attributes)
      attr_on(*attributes)
      begin
        yield
      ensure
        attr_off(*attributes)
      end
    end

    def get_char
      LibNCurses.wgetch(self)
    end

    def no_timeout
      LibNCurses.nodelay(self, false)
      LibNCurses.notimeout(self, true)
    end

    def no_delay
      LibNCurses.notimeout(self, false)
      LibNCurses.nodelay(self, true)
    end

    def timeout=(value)
      LibNCurses.notimeout(self, false)
      LibNCurses.wtimeout(self, value)
    end

    def print(message, position = nil)
      if position
        LibNCurses.mvwprintw(self, position[0], position[1], message)
      else
        LibNCurses.wprintw(self, message)
      end
    end

    def clear
      LibNCurses.wclear(self);
    end

    def refresh
      LibNCurses.wrefresh(self)
    end
  end
end
