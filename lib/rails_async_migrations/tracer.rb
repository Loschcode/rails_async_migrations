# log things and dispatch them wherever
# depending on the context mode
module RailsAsyncMigrations
  class Tracer
    attr_reader :mode

    def initialize(mode)
      @mode = mode
    end

    def verbose(text)
      return unless verbose?

      puts text
    end

    private

    def verbose?
      mode == :verbose
    end
  end
end
