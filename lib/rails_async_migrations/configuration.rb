# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Configuration
    attr_accessor :locked_methods

    def initialize
      @locked_methods = [:change, :up, :down]
    end
  end
end