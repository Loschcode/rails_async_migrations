require 'rails_async_migrations/workers/sidekiq/check_queue_worker'
require 'rails_async_migrations/workers/sidekiq/fire_migration_worker'

# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    ALLOWED = [:check_queue, :fire_migration].freeze
    attr_reader :called_worker

    def initialize(called_worker)
      @called_worker = called_worker # :check_queue, :fire_migration
    end

    def perform(args = nil)
      return unless ALLOWED.include? called_worker
      self.send called_worker, *args
    end

    private

    def check_queue(*args)
      case workers_type
      when :sidekiq
        Workers::Sidekiq::CheckQueueWorker.perform_async(*args)
      when :delayed_job
        Delayed::Job.enqueue Migration::CheckQueue.new
      end
    end

    def fire_migration(*args)
      case workers_type
      when :sidekiq
        Workers::Sidekiq::FireMigrationWorker.perform_async(*args)
      when :delayed_job
        Delayed::Job.enqueue Migration::FireMigration.new(*args)
      end
    end

    def workers_type
      RailsAsyncMigrations.config.workers
    end
  end
end
