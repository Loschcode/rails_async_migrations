require 'rails_async_migrations/workers/sidekiq/check_queue_worker'

RSpec.describe RailsAsyncMigrations::Workers::Sidekiq::CheckQueueWorker do
  it { is_expected.to be_processed_in :default }
end