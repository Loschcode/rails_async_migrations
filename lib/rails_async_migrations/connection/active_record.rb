module RailsAsyncMigrations
  module Connection
    class ActiveRecord
      attr_reader :current_direction

      def initialize(current_direction)
        @current_direction = current_direction
      end

      # NOTE : down isn't available
      # from the public API of the gem
      def current_version
        if current_direction == :down
          migration_context.current_version
        elsif current_direction == :up
          pending_migrations.first
        end
      end

      def current_migration
        @current_migration ||= migration_from current_version
      end

      def migration_from(version)
        migration_context.migrations.find do |migration|
          migration.version.to_s == version.to_s
        end
      end

      def allowed_direction?
        current_direction == :up
      end

      private

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
        @connection || ::ActiveRecord::Base.connection
      end
    end
  end
end
