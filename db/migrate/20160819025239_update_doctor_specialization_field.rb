class UpdateDoctorSpecializationField < ActiveRecord::Migration
  def change
    remove_column :user_profiles, :medical_specialization_id
  end
end
