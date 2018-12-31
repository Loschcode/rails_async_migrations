module RailsAsyncMigrations
  module Mutators
    class TriggerCallback < Base
      attr_reader :instance, :method_name

      def initialize(instance, method_name)
        @instance = instance
        @method_name = method_name
      end

      # this method can be called multiple times (we should see what manages this actually)
      # if you use up down and change it'll be called 3 times for example
      def perform
        return unless active_record.allowed_direction?
        enqueue_asynchronous unless already_enqueued?
        check_queue
      end

      private

      def enqueue_asynchronous
        AsyncSchemaMigration.create!(
          version: active_record.current_version,
          direction: active_record.current_direction,
          state: 'created'
        )
      end

      def already_enqueued?
        AsyncSchemaMigration.find_by(
          version: active_record.current_version,
          direction: active_record.current_direction
        )
      end

      def check_queue
        puts "check queue trigger callback"
        RailsAsyncMigrations::Workers::CheckQueueWorker.perform_async
      end

      def active_record
        @active_record ||= Adapters::ActiveRecord.new(direction)
      end

      def direction
        if instance.reverting?
          :down
        else
          :up
        end
      end
    end
  end
end
