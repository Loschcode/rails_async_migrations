# frozen_string_literal: true
module UtilsHelpers
  def config_worker_as(worker)
    RailsAsyncMigrations.config do |config|
      config.workers = worker
    end
  end

  def config_queue_as(queue)
    RailsAsyncMigrations.config do |config|
      config.queue = queue
    end
  end

  def config_slack_webhook_url_as(slack_webhook_url)
    RailsAsyncMigrations.config do |config|
      config.slack_webhook_url = slack_webhook_url
    end
  end

  def fake_version!
    allow_any_instance_of(
      RailsAsyncMigrations::Connection::ActiveRecord
    ).to(receive(:current_version).and_return("2110010101010"))
  end

  def fake_migrate!
    load("support/db/migrate/2110010101010_fake_migration.rb")
    FakeMigration.new.change
  end

  def fake_migration_proxy!
    allow_any_instance_of(
      RailsAsyncMigrations::Connection::ActiveRecord
    ).to(receive(:migration_from).and_return(
      FakeMigrationProxy.new
    ))
  end

  def disable_async_migrations!
    RailsAsyncMigrations.config do |config|
      config.disable_async_migrations = true
    end
  end
end

class FakeMigrationProxy
  def disable_ddl_transaction
    true
  end

  def migrate(_direction)
    true
  end

  def name
    "FakeMigration"
  end

  def version
    "2110010101010"
  end

  def filename
    "db/migrate/2110010101010_fake_migration.rb"
  end

  def scope
    ""
  end
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
