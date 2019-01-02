# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Migration
    class CheckQueue
      def initialize
      end

      def perform
        Tracer.new.verbose 'Check queue has been triggered'

        return if has_failures?
        return if has_on_going?
        return if no_migration?

        pending!
        fire_migration
      end

      private

      def fire_migration
        Tracer.new.verbose "Migration `#{current_migration.id}` will now be processed"
        Workers.new(:fire_migration).perform(current_migration.id)
      end

      def pending!
        current_migration.update state: 'pending'
      end

      def current_migration
        created_migration
      end

      def processing_migration
        @processing_migration ||= AsyncSchemaMigration.processing.first
      end

      def pending_migration
        @pending_migration ||= AsyncSchemaMigration.pending.first
      end

      def created_migration
        @created_migration ||= AsyncSchemaMigration.created.first
      end

      def no_migration?
        unless current_migration
          Tracer.new.verbose 'No available migration in queue, cancelling check'
          true
        end
      end

      def has_on_going?
        if pending_migration || processing_migration
          Tracer.new.verbose 'Another migration under progress, cancelling check'
          true
        end
      end

      def has_failures?
        if failed_migration
          Tracer.new.verbose 'Failing migration blocking the queue, cancelling check'
          true
        end
      end

      def failed_migration
        @failed_migration ||= AsyncSchemaMigration.failed.first
      end
    end
  end
end