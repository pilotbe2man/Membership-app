class CreateLocaleLogos < ActiveRecord::Migration
  def change
    create_table :locale_logos do |t|
      t.integer :logo_type
      t.attachment :logo
      t.string :language
      t.string :description

      t.timestamps null: false
    end
  end
end
