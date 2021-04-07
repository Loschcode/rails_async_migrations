# frozen_string_literal: true
# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Config
    attr_accessor :taken_methods, :mode, :workers, :queue, :slack_webhook_url, :slack_title_message, :slack_git_url

    def initialize
      @taken_methods = %i[change up down]
      @mode = :quiet # :verbose, :quiet
      @workers = :sidekiq # :delayed_job
      @queue = :default
    end

    def slack_git_url=(value)
      raise ArgumentError.new('slack_git_url must be a URL.') unless value.is_a?(String)
      raise ArgumentError.new('slack_git_url must be a URL.') unless URI.parse(value).kind_of?(URI::HTTP)

      @slack_git_url = value
    end
  end
end
