# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Workers
    attr_reader :called_worker

    def initialize(called_worker)
      @called_worker = called_worker # :check_queue, :fire_migration
    end

    def perform(*args)
      case called_worker
      when :check_queue
        Workers::Sidekiq::CheckQueueWorker.perform_async(*args)
      when :fire_migration
        Workers::Sidekiq::FireMigrationWorker.perform_async(*args)
      end
    end

    def workers_type
      RailsAsyncMigration.config.workers
    end
  end
end
