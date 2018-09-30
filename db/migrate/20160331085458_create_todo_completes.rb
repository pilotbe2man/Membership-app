class CreateTodoCompletes < ActiveRecord::Migration
  def change
    create_table :todo_completes do |t|
      t.integer :submitter_id
      t.integer :todo_id
      t.datetime :completion_date

      t.timestamps null: false
    end
  end
end
