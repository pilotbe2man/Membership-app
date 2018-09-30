class ChangeMessageTargetRole < ActiveRecord::Migration
  def change
    remove_column :messages, :target_role, :integer
    add_column    :messages, :target_roles, :string, array: true, default: []
  end
end
