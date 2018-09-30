class CreateCollaborationInvite < ActiveRecord::Migration
  def change
    create_table :collaboration_invites do |t|
      t.references :child
      t.references :inviter
      t.string     :invitee_email
      t.integer    :status, default: 0
    end
  end
end
