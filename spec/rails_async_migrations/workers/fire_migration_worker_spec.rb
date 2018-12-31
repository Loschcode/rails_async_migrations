RSpec.describe RailsAsyncMigrations::Workers::FireMigrationWorker do
  it { is_expected.to be_processed_in :default }
end