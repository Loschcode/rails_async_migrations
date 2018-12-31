RSpec.describe RailsAsyncMigrations::Migration::Overwrite do
  let(:instance) { described_class.new(class_instance, method_name) }
  let(:class_instance) { FakeMigration.new }
  let(:method_name) { :change }

  context '#perform' do
    subject { instance.perform }
    it { is_expected.to be_falsey }
  end
end