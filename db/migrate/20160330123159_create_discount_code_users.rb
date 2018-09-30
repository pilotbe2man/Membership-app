class CreateDiscountCodeUsers < ActiveRecord::Migration
  def change
    create_table :discount_code_users do |t|
      t.integer :user_id
      t.integer :discount_code_id

      t.timestamps null: false
    end
  end
end
