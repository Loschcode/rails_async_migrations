# reference https://github.com/rails/rails/blob/master/activerecord/lib/active_record/migration.rb
module RailsAsyncMigrations
  module Migration
    def async
      skip_migration
    end

    def skip_migration
      migration_class.include RailsAsyncMigrations::Locker
    end

    def migration_class
      Test
    end

    private

    def migration_context
      connection.migration_context
    end

    def connection
      # NOTE: seems at it was ActiveRecord::Migrator
      # in anterior versions
      @connection || ActiveRecord::Base.connection
    end
  end
end

# FEATURE
# call async in the class to copy `schema_migrations`
# actually make it `async_schema_migrations`
# with same structure and auto process those ones into the async
# and NEVER from the casual migrations
# async!
# split do
# end

# module AsyncMigrations
#   def async
#     # stuff i can put in class
#     # ActiveRecord::Migrator.needs_migration?
#     # ActiveRecord::Migrator.current_version
#   end

#   # def needs_migration?
#   #   current_version < last_version
#   # end

#   def migrate(direction)
#     Test.new(
#       migrator: ActiveRecord::Migrator,
#       direction: direction
#     ).perform
#     # ActiveRecord::Migrator.current_version
#     # ActiveRecord::Migrator.get_all_versions

#     super
#   end
# end

# class Test
#   attr_reader :migrator, :direction

#   def initialize(migrator:, direction:)
#     @migrator = migrator
#     @direction = direction
#   end

#   def perform
#     # can be :up or :down
#     # ActiveRecord::Migrator.new(:up, [migration]).migrate
#     binding.pry
#   end

#   private

#   def current_version
#     migrator.current_version
#   end

#   def versions
#     migrator.get_all_versions
#   end

#   def next_version
#     position = versions.index(current_version)
#     versions[position+1] || versions[position]
#   end

#   def pending_versions
#   end
