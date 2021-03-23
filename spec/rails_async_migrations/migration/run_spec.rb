# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::Overwrite) do
  let(:instance) { described_class.new(direction, version) }
  let(:version) { '00000000' }
  let(:direction) { :up }

  context '#perform' do
    subject { instance.perform }

    it { is_expected.to(be_falsey) }
  end
end
