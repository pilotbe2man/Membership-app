class CreateTodoTasks < ActiveRecord::Migration
  def change
    create_table :todo_tasks do |t|
      t.string :title
      t.text :description
      t.integer :todo_id

      t.timestamps null: false
    end
  end
end
