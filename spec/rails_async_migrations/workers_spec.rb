RSpec.describe RailsAsyncMigrations::Workers do
  let(:called_worker) { :check_queue }
  let(:instance) { described_class.new(called_worker) }
  let(:args) { [] }
  let(:async_schema_migration) do
    AsyncSchemaMigration.create!(
      version: '00000',
      direction: 'up',
      state: 'created'
    )
  end

  subject { instance.perform(args) }

  context 'through delayed_job' do
    before do
      RailsAsyncMigrations.config.workers = :delayed_job
    end

    context 'with :check_queue' do
      it { is_expected.to be_truthy }
    end

    context 'with :fire_migration' do
      let(:called_worker) { :fire_migration }
      let(:args) { [async_schema_migration.id] }

      it { expect { subject }.to raise_error(RailsAsyncMigrations::Error) }
    end
  end

  context 'through sidekiq' do
    context 'with :check_queue' do
      it { is_expected.to be_truthy }
    end

    context 'with :fire_migration' do
      let(:called_worker) { :fire_migration }
      let(:args) { [async_schema_migration.id] }

      it { expect { subject }.to raise_error(RailsAsyncMigrations::Error) }
    end
  end
end