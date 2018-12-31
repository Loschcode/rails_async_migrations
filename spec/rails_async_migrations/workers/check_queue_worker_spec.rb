RSpec.describe RailsAsyncMigrations::Workers::CheckQueueWorker do
  it { is_expected.to be_processed_in :default }
end