RSpec.describe RailsAsyncMigrations::Mutators::TurnAsync do
  let(:instance) { described_class.new(class_instance) }
  let(:class_instance) { FakeMigration.new }

  context '#perform' do
    subject { instance.perform }
    it { is_expected.to be_truthy }
  end
end