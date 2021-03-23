# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations) do
  it 'has a version' do
    expect(RailsAsyncMigrations::VERSION).not_to(be_nil)
  end

  describe '#config' do
    it 'is not null' do
      expect(RailsAsyncMigrations.config).not_to(be_nil)
    end
  end
end
