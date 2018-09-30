class CreateBackJobStatuses < ActiveRecord::Migration
  def change
    create_table :back_job_statuses do |t|
      t.string :job_type
      t.boolean :job_status
      t.string :description

      t.timestamps null: false
    end
  end
end
