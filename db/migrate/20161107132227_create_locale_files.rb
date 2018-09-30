class CreateLocaleFiles < ActiveRecord::Migration
  def change
    create_table :locale_files do |t|
      t.string :name
      t.string :preview_link
      t.timestamps null: false
    end
  end
end
