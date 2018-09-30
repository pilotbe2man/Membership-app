class AddRefIdToIllnesses < ActiveRecord::Migration
  def change
    add_column :illnesses, :ref_id, :string
    add_column :symptoms, :ref_id, :string
    add_column :message_subjects, :ref_id, :string
    add_column :todos, :ref_id, :string
    add_column :todo_tasks, :ref_id, :string
    add_column :sub_tasks, :ref_id, :string
  end
end
