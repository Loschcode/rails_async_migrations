module UtilsHelpers
  def fake_version!
    allow_any_instance_of(
      RailsAsyncMigrations::Connection::ActiveRecord
    ).to receive(:current_version).and_return('00000')
  end

  def fake_migrate!
    load 'support/db/migrate/2010010101010_fake_migration.rb'
    FakeMigration.new.change
  end
end