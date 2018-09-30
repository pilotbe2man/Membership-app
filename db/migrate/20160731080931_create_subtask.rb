class CreateSubtask < ActiveRecord::Migration
  def change
    create_table :sub_tasks do |t|
      t.string     :title
      t.text       :description
      t.references :todo_task
      t.datetime   :deactivated_at
      t.timestamps null: false
    end
  end
end
