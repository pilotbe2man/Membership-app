class AddInviteCodeToCollaborationInvite < ActiveRecord::Migration
  def change
    add_column :collaboration_invites, :invite_code, :string
  end
end
