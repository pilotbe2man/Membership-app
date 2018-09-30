class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :member_type
      t.integer :sub_type
      t.integer :feature
      t.boolean :active
      t.integer :plan

      t.timestamps null: false
    end
  end
end
