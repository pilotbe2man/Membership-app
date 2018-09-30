class CreateTodoTaskCompletes < ActiveRecord::Migration
  def change
    create_table :todo_task_completes do |t|
      t.integer :submitter_id
      t.integer :todo_complete_id
      t.integer :todo_task_id
      t.datetime :completion_date

      t.timestamps null: false
    end
  end
end
