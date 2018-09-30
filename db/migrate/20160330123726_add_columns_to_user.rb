class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :name, :string
    add_column :users, :daycare_id, :integer
    add_column :users, :stripe_customer_token, :string
  end
end
