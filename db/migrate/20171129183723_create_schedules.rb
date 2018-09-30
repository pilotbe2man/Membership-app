class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :appointment_type
      t.datetime :datetime
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
