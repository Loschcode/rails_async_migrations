# log things and dispatch them wherever
# depending on the context mode
# TODO : to fully test
module RailsAsyncMigrations
  class Tracer
    def initialize
    end

    def verbose(text)
      return unless verbose?

      puts text
    end

    private

    def verbose?
      mode == :verbose
    end

    def mode
      RailsAsyncMigrations.config.mode
    end
  end
end
