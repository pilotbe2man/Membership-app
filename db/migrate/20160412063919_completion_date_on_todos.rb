class CompletionDateOnTodos < ActiveRecord::Migration
    def change
        add_column :todos, :completion_date_type, :integer, default: 0
        add_column :todos, :completion_date_value, :integer, default: 1
    end
end
