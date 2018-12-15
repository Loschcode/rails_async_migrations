module RailsAsyncMigrations
  module Mutators
    class Base
      def direction
        instance.reversible do |direction|
          direction.up { @direction = :up }
          direction.down { @direction = :down }
        end

        @direction
      end

      #  Migrator.new(:up, selected_migrations, target_version).migrate
      # TODO : check migration_context.current_version
      def current_migration
        pending_migrations.first
      end

      # TODO this works only when you go forward not backward
      def pending_migrations
        migration_context.migrations.map(&:version) - migration_context.get_all_versions
      end

      def migration_class
        instance.class
      end

      def migration_context
        connection.migration_context
      end

      def connection
        # NOTE: seems at it was ActiveRecord::Migrator
        # in anterior versions
        @connection || ActiveRecord::Base.connection
      end
    end
  end
end
