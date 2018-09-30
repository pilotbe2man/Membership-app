class RemoveDueDateFromTodo < ActiveRecord::Migration
  def change
    remove_column :todos, :due_date
  end
end
