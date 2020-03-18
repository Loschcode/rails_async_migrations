# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  module Migration
    class FireMigration
      attr_reader :migration

      def initialize(migration_id)
        @notifier = Notifier.new
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
        return unless migration.reload.state == 'done'

        @notifier.failed("Migration #{migration.version} is already `done`, cancelling fire")
        return true
      end

      def process!
        @start_time = Time.now

        migration.update! state: 'processing'
        @notifier.processing("Migration #{migration.version} is being processed")
      end

      def done!
        migration.update! state: 'done'
        migration.reload
        @notifier.done("Migration #{migration.version} has been successfully processed in #{execution_time}")
      end

      def failed_with!(error)
        migration.update! state: 'failed'
        @notifier.failed("Migration #{migration.version} failed with exception `#{error}`")
      end

      def execution_time
        exec_time_in_sec = (migration.updated_at - @start_time).to_i

        "#{exec_time_in_sec}s"
      end
    end
  end
end
