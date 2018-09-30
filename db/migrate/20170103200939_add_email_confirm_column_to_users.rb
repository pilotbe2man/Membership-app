class AddEmailConfirmColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmed, :boolean, :default => false
    add_column :users, :confirm_token, :string
    add_column :users, :deposit_required, :boolean, :default => false
  end
end
