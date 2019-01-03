module RailsAsyncMigrations
  module Mutators
    class Base
      # in some context we have to guess it from the file and current connection
      # for instance when we use class methods such as `turn_async`
      def migration_class
        if instance.class == ActiveRecord::Migration
          fetch_from_file
        else
          instance.class
        end
      end

      def fetch_from_file
        require current_migration.filename
        current_migration.name.constantize
      end

      def current_migration
        @current_migration ||= Connection::ActiveRecord.new(:up).current_migration
      end
    end
  end
end
