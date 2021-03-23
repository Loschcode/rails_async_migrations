# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Connection::ActiveRecord) do
  let(:active_record_instance) { resource_class.new }
  let(:direction) { :up }
  let(:instance) { described_class.new(direction) }

  before do
    fake_migration_proxy!
    fake_version!
    fake_migrate!
  end

  context '#current_version' do
    subject { instance.current_version }

    it { is_expected.to(eq('00000')) }
  end

  context '#current_migration' do
    subject { instance.current_migration }

    it { is_expected.to(be_instance_of(FakeMigrationProxy)) }
  end

  context '#migration_from(version)' do
    let(:version) { '000000000' }
    subject { instance.migration_from(version) }

    it { is_expected.to(be_instance_of(FakeMigrationProxy)) }
  end

  context '#allowed_direction?' do
    subject { instance.allowed_direction? }

    it { is_expected.to(be_truthy) }

    context 'with a down direction' do
      let(:direction) { :down }

      it { is_expected.to(be_falsey) }
    end
  end
end
