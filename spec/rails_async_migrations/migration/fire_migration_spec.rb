RSpec.describe RailsAsyncMigrations::Migration::FireMigration do
  let(:instance) { described_class.new(migration) }
  let(:migration) do
    AsyncSchemaMigration.create!(
      version: '00000',
      state: 'created',
      direction: 'up'
    )
  end

  context '#perform' do
    subject { instance.perform }
    it { expect { subject }.to raise_error(RailsAsyncMigrations::Error) }
  end
end