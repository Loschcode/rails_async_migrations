# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Migration
    class FireMigration
      attr_reader :migration

      def initialize(migration_id)
        @migration = AsyncSchemaMigration.find(migration_id)
      end

      def perform
        return if done?

        process!
        run_migration
        done!

        check_queue
      end

      private

      def check_queue
        Workers.new(:check_queue).perform
      end

      def run_migration
        Migration::Run.new(migration.direction, migration.version).perform
      rescue Exception => exception
        failed_with! exception
        raise
      end

      def done?
        if migration.reload.state == 'done'
          Tracer.new.verbose "Migration #{migration.version} is already `done`, cancelling fire"
          return true
        end
      end

      def process!
        migration.update! state: 'processing'
      end

      def done!
        migration.update! state: 'done'
        Tracer.new.verbose "Migration #{migration.version} was correctly processed"
        migration.reload
      end

      def failed_with!(error)
        migration.update! state: 'failed'
        Tracer.new.verbose "Migration #{migration.version} failed with exception `#{error}`"
      end
    end
  end
end
