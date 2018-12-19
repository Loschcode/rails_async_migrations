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
        # run_migration
        lock_migration_methods
      end

      private

      # TODO : this is not the correct logic
      # because it uses the normal migration database schema
      # and this crahses the system.
      def run_migration
        migrator_instance.migrate
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

      # TODO : not sure it's useful this one
      def lock_migration_methods
        locked_methods.each do |method_name|
          Migration::Lock.new(class_name, method_name).perform
        end
      end
    end
  end
end