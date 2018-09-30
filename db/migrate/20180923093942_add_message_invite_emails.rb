class AddMessageInviteEmails < ActiveRecord::Migration
  def change
  	create_table :message_invite_emails do |t|
      t.references :user, index: true
      t.string 'role', null: false
      t.string 'department', null: false
      t.string 'email', null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end