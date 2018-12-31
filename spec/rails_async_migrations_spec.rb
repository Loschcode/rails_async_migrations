RSpec.describe RailsAsyncMigrations do
  it { expect(RailsAsyncMigrations::VERSION).not_to be_nil }
  it { expect(RailsAsyncMigrations.config).not_to be_nil }
end
