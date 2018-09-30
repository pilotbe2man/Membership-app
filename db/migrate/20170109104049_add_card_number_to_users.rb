class AddCardNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :card_number, :string
    add_column :subscriptions, :month, :integer
    add_column :subscriptions, :discount_code_id, :integer
    add_column :subscriptions, :transaction_id, :integer
  end
end
