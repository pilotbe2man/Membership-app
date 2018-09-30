class AddDaycareNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daycare_name, :string
  end
end
