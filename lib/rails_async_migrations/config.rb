# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Config
    attr_accessor :taken_methods, :mode, :workers, :queue, :slack_webhook_url, :slack_title_message

    def initialize
      @taken_methods = %i[change up down]
      @mode = :quiet # :verbose, :quiet
      @workers = :delayed_job # :sidekiq
      @queue = :default
    end
  end
end
