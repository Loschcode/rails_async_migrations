# log things and dispatch them wherever
# depending on the context mode
module RailsAsyncMigrations
  class Tracer
    def initialize
    end

    def verbose(text)
      return unless verbose?
      puts "[VERBOSE] #{text}"
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