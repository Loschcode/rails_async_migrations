# to run actual migration we need to require the migration files
module RailsAsyncMigrations
  module Migration
    class Run
      attr_reader :direction, :version, :migration

      def initialize(direction, version)
        @direction = direction
        @version = version
        @migration = migration_from version

        ensure_data_consistency
        require "#{Rails.root}/#{migration.filename}" if defined? Rails
      end

      def perform
        give_migration_methods
        delete_migration_state
        run_migration
        delete_migration_state
        take_migration_methods
      end

      private

      def migration_from(version)
        Connection::ActiveRecord.new(direction).migration_from version
      end

      def run_migration
        migrator_instance.migrate
      end

      def migrator_instance
        @migrator_instance ||= ::ActiveRecord::Migrator.new(direction.to_sym, [migration], ::ActiveRecord::SchemaMigration)
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

      def taken_methods
        RailsAsyncMigrations.config.taken_methods
      end

      def give_migration_methods
        taken_methods.each do |method_name|
          Migration::Give.new(class_name, method_name).perform
        end
      end

      def take_migration_methods
        taken_methods.each do |method_name|
          Migration::Take.new(class_name, method_name).perform
        end
      end

      def ensure_data_consistency
        unless migration
          raise RailsAsyncMigrations::Error, "No migration from version `#{version}`"
        end
      end
    end
  end
end
