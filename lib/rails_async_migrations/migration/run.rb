# to run actual migration we need to require the migration files
module RailsAsyncMigrations
  module Migration
    class Run
      attr_reader :direction, :version, :migration

      def initialize(direction, version)
        @direction = direction
        @version = version
        @migration = migration_from version

        require "#{Rails.root}/#{migration.filename}"
      end

      def perform
        unlock_migration_methods
        delete_migration_state
        run_migration
        delete_migration_state
        lock_migration_methods
      end

      private

      def migration_from(version)
        Adapters::ActiveRecord.new(direction).migration_from version
      end

      def run_migration
        # TODO : improve this by launching all methods defined
        class_name.new.change
      end

      def schema_migration
        @schema_migration ||= ActiveRecord::SchemaMigration.find_by(version: version)
      end

      def delete_migration_state
        schema_migration&.delete
      end

      def class_name
        migration.name.constantize
      end

      def locked_methods
        RailsAsyncMigrations.config.locked_methods
      end

      def unlock_migration_methods
        locked_methods.each do |method_name|
          Migration::Unlock.new(class_name, method_name).perform
        end
      end

      def lock_migration_methods
        locked_methods.each do |method_name|
          Migration::Lock.new(class_name, method_name).perform
        end
      end
    end
  end
end