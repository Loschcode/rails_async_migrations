# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::Give) do
  let(:instance) { described_class.new(resource_class, method_name) }
  let(:resource_class) { FakeMigration }
  let(:method_name) { :change }

  context "#perform" do
    subject { instance.perform }

    it { is_expected.to(be_truthy) }
  end
end
