class CreateAsyncSchemaMigrations < ActiveRecord::Migration[5.2]
  def change
    create_table :async_schema_migrations do |t|
      t.integer :version
      t.text :direction
      t.text :state

      t.timestamps
    end
  end
end
