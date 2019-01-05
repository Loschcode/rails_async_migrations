# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Config
    attr_accessor :locked_methods, :mode, :workers

    def initialize
      @locked_methods = %i[change up down]
      @mode = :quiet # :verbose, :quiet
      @workers = :delayed_job # :sidekiq
    end
  end
end
