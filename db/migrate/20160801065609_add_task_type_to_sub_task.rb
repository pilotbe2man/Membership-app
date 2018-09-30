class AddTaskTypeToSubTask < ActiveRecord::Migration
  def change
    add_column :sub_tasks, :sub_task_type, :integer, default: 0
  end
end
