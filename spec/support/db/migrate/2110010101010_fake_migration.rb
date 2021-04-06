# frozen_string_literal: true
class FakeMigration < ActiveRecord::Migration[6.0]
  turn_async

  def change
    create_table('tests') do |t|
      t.string(:test)
    end
  end
end
