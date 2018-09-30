class AddIsActiveToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :is_active, :integer, default: 1
  end
end
