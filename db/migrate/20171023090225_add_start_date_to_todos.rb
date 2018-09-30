class AddStartDateToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :start_date, :datetime
    add_column :todos, :start_days, :string
  end
end
