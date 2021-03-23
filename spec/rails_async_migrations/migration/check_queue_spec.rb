# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::CheckQueue) do
  let(:instance) { described_class.new }

  context '#perform' do
    subject { instance.perform }

    it { is_expected.to(be_falsey) }
  end
end
