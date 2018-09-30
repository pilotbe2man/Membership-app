class CreateDepartmentTodos < ActiveRecord::Migration
  def change
    create_table :department_todos do |t|
      t.integer :todo_id
      t.integer :department_id

      t.timestamps null: false
    end
  end
end
