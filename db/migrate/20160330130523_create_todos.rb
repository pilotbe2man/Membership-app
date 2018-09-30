class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.datetime :due_date
      t.integer :iteration_type, default: 0
      t.integer :frequency, default: 0
      t.integer :daycare_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
