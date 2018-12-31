namespace :rails_async_migrations do
  desc 'Check our current asynchronous queue and fire migrations if possible'
  task :check_queue do
    RailsAsyncMigrations::Workers::CheckQueueWorker.perform_async
  end
end
