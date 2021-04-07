# frozen_string_literal: true
module RailsAsyncMigrations
  module Migration
    module MarkdownMigration
      extend self

      def call(async_migration:)
        migration = migration(async_migration)
        name = migration_name(migration)
        url = migration_url(migration)

        markdown_migration(version: async_migration.version, name: name, url: url)
      end

      private

      def markdown_migration(version:, name:, url:)
        return version if name.nil?

        "#{markdown_name(name)} #{markdown_version(version: version, url: url)}"
      end

      def markdown_name(name)
        "*#{name}*"
      end

      def markdown_version(version:, url:)
        return "`#{version}`" if url.nil?

        "[#{version}](#{url})"
      end

      def migration(async_migration)
        Connection::ActiveRecord
          .new(async_migration.direction)
          .migration_from(async_migration.version)
      end

      def migration_name(migration)
        migration&.name&.titleize
      end

      def migration_filename(migration)
        migration&.filename
      end

      def migration_url(migration)
        return unless defined?(Rails)
        return if in_rails_dev_or_test_env?
        return if slack_git_url.nil?

        "#{slack_git_url}/#{migration_filename(migration)}"
      end

      def in_rails_dev_or_test_env?
        rails_env.development? || rails_env.test?
      end

      def rails_env
        ::Rails.env
      end

      def slack_git_url
        RailsAsyncMigrations.config.slack_git_url
      end
    end
  end
end
