class AddOwnerToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :owner_id, :integer
  end
end
