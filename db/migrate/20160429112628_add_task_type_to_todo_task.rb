class AddTaskTypeToTodoTask < ActiveRecord::Migration
    def change
        add_column :todo_tasks, :task_type, :integer, default: 0
    end
end
