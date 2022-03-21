# frozen_string_literal: true
# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    ALLOWED = [:check_queue, :fire_migration].freeze
    attr_reader :called_worker

    def initialize(called_worker)
      @called_worker = called_worker # :check_queue, :fire_migration
      ensure_worker_presence
    end

    def perform(args = [])
      return unless ALLOWED.include?(called_worker)

      send(called_worker, *args)
    end

    private

    def check_queue(*args)
      case workers_type
      when :sidekiq
        Workers::Sidekiq::CheckQueueWorker.set(queue: default_queue).perform_async(*args)
      when :delayed_job
        ::Delayed::Job.enqueue(Migration::CheckQueue.new)
      end
    end

    def fire_migration(*args)
      case workers_type
      when :sidekiq
        Workers::Sidekiq::FireMigrationWorker.set(queue: default_queue).perform_async(*args)
      when :delayed_job
        ::Delayed::Job.enqueue(Migration::FireMigration.new(*args))
      end
    end

    def workers_type
      RailsAsyncMigrations.config.workers
    end

    def default_queue
      RailsAsyncMigrations.config.queue
    end

    def ensure_worker_presence
      case workers_type
      when :sidekiq
        unless defined? ::Sidekiq::Worker
          raise Error, "Please install Sidekiq before to set it as worker adapter"
        end
      when :delayed_job
        unless defined? ::Delayed::Job
          raise Error, "Please install Delayed::Job before to set it as worker adapter"
        end
      end
    end
  end
end
