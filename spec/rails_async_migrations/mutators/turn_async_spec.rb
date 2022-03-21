# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Mutators::TurnAsync) do
  
  describe "#perform" do
    let(:instance) { described_class.new(migration_class) }
    let(:migration_class) { FakeMigration }

    context "async migrations enabled" do
      subject { instance.perform }
      it { is_expected.to(be_truthy) }
    end
  end
end
