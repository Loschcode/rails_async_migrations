# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Config
    attr_accessor :locked_methods, :mode

    def initialize
      @locked_methods = %i[change up down]
      @mode = :quiet # %i[verbose quiet]
    end
  end
end
