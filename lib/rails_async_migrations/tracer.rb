# log things and dispatch them wherever
# depending on the context mode
module RailsAsyncMigrations
  class Tracer
    attr_reader :mode

    def initialize(mode)
      @mode = mode
    end

    def notice(text)
      if mode == :verbose
        puts text
      end
    end
  end
end
