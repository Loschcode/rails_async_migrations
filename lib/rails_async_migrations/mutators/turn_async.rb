module RailsAsyncMigrations
  module Mutators
    class TurnAsync < Base
      attr_reader :instance

      def initialize(instance)
        @instance = instance
      end

      def perform
        puts "turn_async called"
        alter_migration
      end

      private

      def alter_migration
        migration_class.include RailsAsyncMigrations::Migration
      end
    end
  end
end