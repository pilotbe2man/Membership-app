class AddUniqIndexToMessageInviteEmails < ActiveRecord::Migration
  def change
  	add_index :message_invite_emails, [:user_id, :role, :department, :email], unique: true, name: 'message_invite_emails_index'
  end
end
