class AddSectionToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :section, :string, default: 'a'
  end
end
