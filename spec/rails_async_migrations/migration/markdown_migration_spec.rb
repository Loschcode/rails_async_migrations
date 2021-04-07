# frozen_string_literal: true
RSpec.describe(RailsAsyncMigrations::Migration::MarkdownMigration) do
  let(:async_migration) do
    AsyncSchemaMigration.create!(
      version: '2110010101010',
      state: 'created',
      direction: 'up'
    )
  end
  let(:migration) do
    instance_double(
      ActiveRecord::MigrationProxy, 
      name: 'FakeMigration',
      version: 2110010101010,
      filename: 'db/migrate/2110010101010_fake_migration.rb'
    )
  end 

  describe '#call' do
    before do
      # to allow `defined?(Rails) => true
      stub_const("Rails", Object)
      allow(described_class).to(receive(:rails_env).and_return('test'))
      allow(described_class).to(receive(:in_rails_dev_or_test_env?).and_return(true))
    end

    context 'when there is no associated migration' do
      subject { described_class.call(async_migration: async_migration) }
      before { allow(described_class).to(receive(:migration).and_return(nil)) }
      
      it { is_expected.to(eq(async_migration.version)) }
    end

    context 'when there an associated migration' do
      subject { described_class.call(async_migration: async_migration) }
      before { allow(described_class).to(receive(:migration).and_return(migration)) }
      
      context 'when in the dev or test rails env' do
        it { is_expected.to(eq("*#{migration.name.titleize}* `#{migration.version}`")) }
      end

      context 'when not in the dev or test rails env' do
        let(:url) { 'https://github.com/Hivebrite/rails_async_migrations/blob/master' }

        before do
          allow(described_class).to(receive(:slack_git_url).and_return(url))
          allow(described_class).to(receive(:rails_env).and_return('env'))
          allow(described_class).to(receive(:in_rails_dev_or_test_env?).and_return(false))
        end

        it { is_expected.to(eq("*#{migration.name.titleize}* [#{migration.version}](#{url}/#{migration.filename})")) }
      end
    end
  end
end
