namespace :rails_async_migrations do
  desc 'Check our current asynchronous queue and fire migrations if possible'
  task check_queue: :environment do
    RailsAsyncMigrations::Workers.new(:check_queue).perform
  end
end
