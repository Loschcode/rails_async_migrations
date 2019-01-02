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

  # def fake_connection!
  #   allow(::ActiveRecord::Base).to receive(:connection).and_return(FakeConnection.new)
  # end

  #  class FakeConnection
  #   def migration_context
  #     FakeMigrationContext.new
  #   end
  #  end

  #  class FakeMigrationContext
  #   def migrations
  #     [FakeProxy.new]
  #   end

  #   def get_all_versions
  #     [FakeProxy.new]
  #   end
  #  end

  #  class FakeProxy
  #   def version
  #     000000000
  #   end
  #  end
end