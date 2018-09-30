class ChangeForeignKeyOnTodo < ActiveRecord::Migration
  def change
    add_column :todos, :department_id, :integer
  end
end
