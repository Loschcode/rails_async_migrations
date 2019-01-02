require 'rails_async_migrations/workers/sidekiq/fire_migration_worker'

RSpec.describe RailsAsyncMigrations::Workers::Sidekiq::FireMigrationWorker do
  it { is_expected.to be_processed_in :default }
end