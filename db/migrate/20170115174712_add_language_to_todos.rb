class AddLanguageToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :language, :string
    add_column :illnesses, :language, :string
    add_column :todo_tasks, :language, :string
    add_column :sub_tasks, :language, :string
    add_column :message_subjects, :language, :string
  end
end
