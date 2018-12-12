# overwrites the locked methods with some logic
# this may turn the method into a logger
# in verbose mode
module RailsAsyncMigrations
  module Locker
    class Overwrite
      attr_reader :instance

      def initialize(instance)
        @instance = instance
      end

      def perform
        tracer.notice('was overwritten')
      end

      private

      def tracer
        @tracer ||= Tracer.new(mode)
      end

      def mode
        RailsAsyncMigrations.config.mode
      end
    end
  end
end
