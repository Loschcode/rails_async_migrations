RSpec.describe RailsAsyncMigrations::Mutators::TurnAsync do
  let(:instance) { described_class.new(migration_class) }
  let(:migration_class) { FakeMigration }

  context '#perform' do
    subject { instance.perform }
    it { is_expected.to be_truthy }
  end
end