class AddStatusAndResultToTodoDataStructure < ActiveRecord::Migration
  def change
    add_column :todo_completes, :status, :integer, default: 0
    add_column :todo_task_completes, :result, :integer, default: 0
  end
end
