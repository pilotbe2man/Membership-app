class AddDaycareToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :daycare_id, :integer, default: 0
    add_column :permissions, :partner_id, :integer, default: 0
  end
end
