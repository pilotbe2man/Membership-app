class AddPathToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :path, :string
    add_column :permissions, :guide_path, :string
    add_column :permissions, :element, :string
    add_column :permissions, :image, :string
    add_column :permissions, :label_key, :string
  end
end
