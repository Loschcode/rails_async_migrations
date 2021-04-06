# frozen_string_literal: true
# configuration of the gem and
# default values set here
module RailsAsyncMigrations
  class Config
    attr_accessor :taken_methods, :mode, :workers, :queue, :slack_webhook_url, :slack_title_message, :slack_git_url_mapping_for_envs

    def initialize
      @taken_methods = %i[change up down]
      @mode = :quiet # :verbose, :quiet
      @workers = :sidekiq # :delayed_job
      @queue = :default
    end

    def slack_git_url_mapping_for_envs=(value)
      raise ArgumentError.new('slack_git_url_mapping_for_envs must be a hash.') unless value.is_a?(Hash)
      raise ArgumentError.new('slack_git_url_mapping_for_envs hash values must be URLs.') unless value.values.all? { URI.parse(_1).kind_of?(URI::HTTP) }

      @slack_git_url_mapping_for_envs = value
    end
  end
end
