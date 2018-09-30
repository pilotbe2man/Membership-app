class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.string :code
      t.decimal :value, default: 0.0
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
