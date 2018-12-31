class FakeMigration < ActiveRecord::Migration[5.2]
  turn_async

  def change
    create_table 'tests' do |t|
      t.string :test
    end
  end
end
