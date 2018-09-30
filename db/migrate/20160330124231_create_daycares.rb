class CreateDaycares < ActiveRecord::Migration
  def change
    create_table :daycares do |t|
      t.string :name
      t.string :address_line1
      t.string :postcode
      t.string :country
      t.string :telephone

      t.timestamps null: false
    end
  end
end
