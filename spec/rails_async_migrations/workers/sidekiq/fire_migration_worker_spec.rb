
RSpec.describe RailsAsyncMigrations::Workers::Sidekiq::FireMigrationWorker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable false }

  context 'when the queue is default' do
    before { config_queue_as :default }

    it { is_expected.to be_processed_in :default }
  end
end
