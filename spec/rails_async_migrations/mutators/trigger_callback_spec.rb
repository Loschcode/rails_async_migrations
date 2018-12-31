RSpec.describe RailsAsyncMigrations::Mutators::TriggerCallback do
  let(:instance) { described_class.new(class_instance, method_name) }
  let(:class_instance) { FakeMigration.new }
  let(:method_name) { :change }

  before do
    allow_any_instance_of(
      RailsAsyncMigrations::Adapters::ActiveRecord
    ).to receive(:current_version).and_return('00000')
  end

  context '#perform' do
    subject { instance.perform }
    it { is_expected.to be_truthy }
  end
end