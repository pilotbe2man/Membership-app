class RemoveDepartmentIdFromTodos < ActiveRecord::Migration
  def change
    remove_column :todos, :department_id
  end
end
