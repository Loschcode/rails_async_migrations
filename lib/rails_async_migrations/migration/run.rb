module RailsAsyncMigrations
  module Migration
    class Run
      attr_reader :direction, :migration

      def initialize(direction, migration)
        @direction = direction
        @migration = migration
      end

      def perform
        unlock_migration_methods
        delete_migration_state
        run_migration
        delete_migration_state
        lock_migration_methods
      end

      private

      def run_migration
        migrator_instance.migrate
      end

      def delete_migration_state
        ActiveRecord::SchemaMigration.find_by(version: migration.version)&.delete
      end

      def migrator_instance
        @migrator_instance ||= ActiveRecord::Migrator.new(direction, [migration])
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