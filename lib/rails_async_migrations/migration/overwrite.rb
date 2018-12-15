module RailsAsyncMigrations
  module Migration
    class Overwrite < Base
      attr_reader :instance, :method_name

      def initialize(instance, method_name)
        @instance = instance
        @method = method
      end

      def perform
        dispatch_trace
        trigger_callback
      end

      private

      def dispatch_trace
        tracer.verbose("#{instance.class}\##{method_name} was called in a locked state")
      end

      def trigger_callback
        instance.trigger_callback(method_name) if defined? :trigger_callback
      end

      def tracer
        @tracer ||= Tracer.new
      end
    end
  end
end
