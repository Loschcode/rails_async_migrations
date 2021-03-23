# frozen_string_literal: true
class CreateAsyncSchemaMigrations < ActiveRecord::Migration[6.0]
  def change
    create_table(:async_schema_migrations) do |t|
      t.string(:version)
      t.string(:direction)
      t.string(:state)

      t.timestamps
    end
  end
end
