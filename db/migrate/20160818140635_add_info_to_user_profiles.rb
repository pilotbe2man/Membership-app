class AddInfoToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :medical_specialization_id, :integer
    add_column :user_profiles, :certifications, :text, array: true, default: []
  end
end
