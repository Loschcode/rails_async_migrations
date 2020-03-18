# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    module Sidekiq
      class FireMigrationWorker
        include ::Sidekiq::Worker

        sidekiq_options queue: :default, retry: false

        def perform(migration_id)
          Migration::FireMigration.new(
            migration_id
          ).perform
        end
      end
    end
  end
end
