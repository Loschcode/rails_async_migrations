# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    module Sidekiq
      class CheckQueueWorker
        include ::Sidekiq::Worker

        sidekiq_options queue: :default, retry: false

        def perform
          Migration::CheckQueue.new.perform
        end
      end
    end
  end
end
