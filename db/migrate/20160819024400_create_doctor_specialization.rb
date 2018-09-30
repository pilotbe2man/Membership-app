class CreateDoctorSpecialization < ActiveRecord::Migration
  def change
    create_table :doctor_specializations do |t|
      t.references :user_profile
      t.references :medical_specialization
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
