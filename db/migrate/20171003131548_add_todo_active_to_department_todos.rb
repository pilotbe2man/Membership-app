class AddTodoActiveToDepartmentTodos < ActiveRecord::Migration
  def change
    add_column :department_todos, :todo_active, :boolean, default: true
  end
end
