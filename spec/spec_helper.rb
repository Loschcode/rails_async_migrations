require 'bundler/setup'
require 'pry'
require 'rails_async_migrations'

require 'logger'
require 'database_cleaner'
require 'delayed_job_active_record'
require 'rspec-sidekiq'
require 'shoulda-matchers'
require "fantaskspec"

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.infer_rake_task_specs_from_file_location!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
  )
  ActiveRecord::Schema.verbose = false

  # Add additional requires below this line. Rails is not loaded until this point!
  Dir['spec/support/**/*.rb', 'lib/tasks/**/*.rake'].each do |file|
    load file
  end

  config.include UtilsHelpers

  load 'support/db/schema.rb'
  load 'support/db/migrate/2010010101010_fake_migration.rb'
  ActiveRecord::Migrator.migrations_paths << 'support/db/migrate'

  DatabaseCleaner.strategy = :truncation

  config.before :each do
    Delayed::Worker.delay_jobs = false
    DatabaseCleaner.start
  end

  config.after :each do
    Delayed::Worker.delay_jobs = true
    DatabaseCleaner.clean
  end
end

RSpec::Sidekiq.configure do |config|
  config.clear_all_enqueued_jobs = true
  config.enable_terminal_colours = true
  config.warn_when_jobs_not_processed_by_sidekiq = true
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end
