class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price, default: 0.0
      t.integer :allocation, default: 0

      t.timestamps null: false
    end
  end
end
