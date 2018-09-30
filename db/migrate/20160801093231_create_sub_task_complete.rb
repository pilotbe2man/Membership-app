class CreateSubTaskComplete < ActiveRecord::Migration
  def change
    create_table :sub_task_completes do |t|
      t.integer    :submitter_id
      t.references :todo_task_complete
      t.references :sub_task
      t.datetime   :completion_date

      t.timestamps null: false
    end
  end
end
