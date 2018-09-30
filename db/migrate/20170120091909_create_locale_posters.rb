class CreateLocalePosters < ActiveRecord::Migration
  def change
    create_table :locale_posters do |t|
      t.integer :poster_type
      t.attachment :poster
      t.string :language
      t.string :description

      t.timestamps null: false
    end
  end
end
