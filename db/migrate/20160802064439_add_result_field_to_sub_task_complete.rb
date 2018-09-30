class AddResultFieldToSubTaskComplete < ActiveRecord::Migration
  def change
    add_column :sub_task_completes, :result, :integer, default: 0
  end
end
