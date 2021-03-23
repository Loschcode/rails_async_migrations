# frozen_string_literal: true
module RailsAsyncMigrations
  class Notifier
    def initialize
      @notifier = ::Slack::Notifier.new(slack_webhook_url) if slack_webhook_url
    end

    def processing(text)
      post(text: text, color: 'warning')
    end

    def failed(text)
      post(text: text, color: 'danger')
    end

    def done(text)
      post(text: text, color: 'good')
    end

    def verbose(text)
      return unless verbose?

      puts "[VERBOSE] #{[slack_title_message, text].compact.join(' - ')}"
    end

    private

    def post(params)
      return verbose(params[:text]) if verbose?

      params[:title] = slack_title_message if slack_title_message

      @notifier&.post(attachments: [params])
    end

    def slack_webhook_url
      RailsAsyncMigrations.config.slack_webhook_url.presence
    end

    def verbose?
      mode == :verbose
    end

    def mode
      RailsAsyncMigrations.config.mode
    end

    def slack_title_message
      RailsAsyncMigrations.config.slack_title_message
    end
  end
end
