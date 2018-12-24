module RailsAsyncMigrations
  module Adapters
    class ActiveRecord
      def current_version
        if current_direction == :down
          migration_context.current_version
        elsif current_direction == :up
          pending_migrations.first
        end
      end

      def current_direction
        if instance.reverting?
          :down
        else
          :up
        end
      end

      def allowed_direction?
        current_direction == :up
      end

      private

      def migration
        @migration ||= migration_from current_version
      end

      def migration_from(version)
        migration_context.migrations.find do |migration|
          migration.version == version
        end
      end

      def pending_migrations
        achieved_migrations - all_migrations
      end

      def achieved_migrations
        migration_context.migrations.collect(&:version)
      end

      def all_migrations
        migration_context.get_all_versions
      end

      def migration_context
        connection.migration_context
      end

      # NOTE: seems at it was ActiveRecord::Migrator
      # in anterior versions
      def connection
        @connection || ActiveRecord::Base.connection
      end
    end
  end
end