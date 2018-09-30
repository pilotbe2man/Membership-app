class CreateMeetingUsers < ActiveRecord::Migration
  def change
    create_table :meeting_users do |t|
      t.string :email
      t.string :name
      t.string :daycare_name
      t.string :mobile
      t.string :token

      t.timestamps null: false
    end
  end
end
