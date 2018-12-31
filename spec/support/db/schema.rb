ActiveRecord::Schema.define(version: 2018_12_17_201613) do
  # These are extensions that must be enabled in order to support this database
  # enable_extension "plpgsql"

  create_table "async_schema_migrations", force: :cascade do |t|
    t.string "version"
    t.string "direction"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end