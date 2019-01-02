RSpec.describe RailsAsyncMigrations::Workers::Sidekiq::CheckQueueWorker do
  it { is_expected.to be_processed_in :default }
end