class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string :name
      t.integer :parent_id
      t.integer :department_id
      t.datetime :birth_date

      t.timestamps null: false
    end
  end
end
