module RailsAsyncMigrations
  module Migration
    class Overwrite
      attr_reader :instance, :method_name

      def initialize(instance, method_name)
        @instance = instance
        @method_name = method_name
      end

      def perform
        dispatch_notify
        trigger_callback
      end

      private

      def dispatch_notify
        Notifier.new.verbose "#{instance.class}\##{method_name} was called in a taken state"
      end

      def trigger_callback
        instance.send(:trigger_callback, method_name)
      rescue NoMethodError
      end
    end
  end
end
