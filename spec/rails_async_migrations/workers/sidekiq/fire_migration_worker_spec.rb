RSpec.describe RailsAsyncMigrations::Workers::Sidekiq::FireMigrationWorker do
  it { is_expected.to be_processed_in :default }
end