# frozen_string_literal: true
module RailsAsyncMigrations
  module Mutators
    class TurnAsync < Base
      attr_reader :migration_class

      def initialize(migration_class)
        @migration_class = migration_class
      end

      def perform
        Notifier.new.verbose("`turn_async` has been triggered")
        alter_migration
      end

      private

      def alter_migration
        Notifier.new.verbose("#{migration_class} is now asynchronous")
        migration_class.include(RailsAsyncMigrations::Migration)
      end
    end
  end
end
