class AddDefaultPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_password_token, :string
  end
end
