class CreateMunicipals < ActiveRecord::Migration
  def change
    create_table :municipals do |t|
      t.integer :ref_id
      t.string :name
      t.string :state
      t.integer :municipal_type
      t.string :language

      t.timestamps null: false
    end
  end
end
