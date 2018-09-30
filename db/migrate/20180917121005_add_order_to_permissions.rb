class AddOrderToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :order, :integer, default: 0
  end
end
