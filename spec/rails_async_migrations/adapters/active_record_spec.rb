RSpec.describe RailsAsyncMigrations::Adapters::ActiveRecord do
  let(:active_record_instance) { resource_class.new }
  let(:direction) { :up }
  let(:instance) { described_class.new(direction) }

  before do
    fake_migrate!
  end

  context '#current_version' do
    subject { instance.current_version }
    it { is_expected.to be_falsey }
  end

  context '#current_migration' do
    subject { instance.current_migration }
    it { is_expected.to be_falsey }
  end

  context '#migration_from(version)' do
    let(:version) { 000000000 }
    subject { instance.migration_from(version) }
    it { is_expected.to be_falsey }
  end

  context '#allowed_direction?' do
    subject { instance.allowed_direction? }

    it { is_expected.to be_truthy }
    context 'with a down direction' do
      let(:direction) { :down }
      it { is_expected.to be_falsey }
    end
  end
end

def fake_migrate!
  load 'support/db/migrate/2010010101010_fake_migration.rb'
  FakeMigration.new.change
end

# def fake_connection!
#   allow(::ActiveRecord::Base).to receive(:connection).and_return(FakeConnection.new)
# end

#  class FakeConnection
#   def migration_context
#     FakeMigrationContext.new
#   end
#  end

#  class FakeMigrationContext
#   def migrations
#     [FakeProxy.new]
#   end

#   def get_all_versions
#     [FakeProxy.new]
#   end
#  end

#  class FakeProxy
#   def version
#     000000000
#   end
#  end