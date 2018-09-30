class CreateUserProfile < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.integer    :phone_number
      t.string     :physical_address
      t.string     :web_address
      t.string     :about_yourself
      t.string     :education
      t.boolean    :online_presence, default: true
    end
  end
end
