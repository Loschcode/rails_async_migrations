# frozen_string_literal: true
ActiveRecord::Schema.define(version: 2018_12_17_201613) do
  create_table "async_schema_migrations", force: :cascade do |t|
    t.string("version")
    t.string("direction")
    t.string("state")
    t.datetime("created_at", null: false)
    t.datetime("updated_at", null: false)
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer("priority", default: 0, null: false)
    t.integer("attempts", default: 0, null: false)
    t.text("handler", null: false)
    t.text("last_error")
    t.datetime("run_at")
    t.datetime("locked_at")
    t.datetime("failed_at")
    t.string("locked_by")
    t.string("queue")
    t.datetime("created_at")
    t.datetime("updated_at")
    t.index(["priority", "run_at"], name: "delayed_jobs_priority")
  end
end
