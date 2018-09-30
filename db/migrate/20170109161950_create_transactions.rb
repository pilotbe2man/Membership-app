class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	
      t.decimal :amount, precision: 8, scale: 2
      t.string  :currency
      t.string  :card_num
      t.string  :charge_id
      t.integer :user_id
      t.boolean :deposit, default: false

      t.timestamps null: false
    end
  end
end
