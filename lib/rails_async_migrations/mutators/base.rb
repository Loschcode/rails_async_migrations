module RailsAsyncMigrations
  module Mutators
    class Base
      # in some context we have to guess it from the file and current connection
      # for instance when we use class methods such as `turn_async`
      def migration_class
        fetch_from_file || instance.class
      end

      def fetch_from_file
        return unless current_migration
        require current_migration.filename
        current_migration.name.constantize
      end

      def current_migration
        @current_migration ||= Connection::ActiveRecord.new(:up).current_migration
      end
    end
  end
end
