class CreateUserDaycares < ActiveRecord::Migration
  def change
    create_table :user_daycares do |t|
      t.integer :user_id
      t.integer :daycare_id

      t.timestamps null: false
    end
  end
end
