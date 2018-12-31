require 'bundler/setup'
require 'pry'
require 'rails_async_migrations'

require 'logger'
require 'database_cleaner'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
  )
  ActiveRecord::Schema.verbose = false

  load 'support/db/schema.rb'
  ActiveRecord::Migrator.migrations_paths << 'support/db/migrate'
  

  DatabaseCleaner.strategy = :truncation

  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end