RSpec.describe RailsAsyncMigrations::Mutators::TriggerCallback do
  let(:instance) { described_class.new(class_instance, method_name) }
  let(:class_instance) { FakeMigration.new }
  let(:method_name) { :change }

  before do
    fake_version!
  end

  context '#perform' do
    subject { instance.perform }
    it { is_expected.to be_truthy }
  end
end