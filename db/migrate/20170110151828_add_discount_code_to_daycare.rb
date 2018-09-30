class AddDiscountCodeToDaycare < ActiveRecord::Migration
  def change
    add_column :daycares, :discount_code_id, :integer, :default => 0
    add_column :daycares, :payment_month, :integer, :default => 0
  end
end
