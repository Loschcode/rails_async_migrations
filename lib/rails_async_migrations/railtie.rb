module RailsAsyncMigrations
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/rails_async_migrations.rake'
    end
  end
end