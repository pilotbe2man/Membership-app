class CreateLocaleUrls < ActiveRecord::Migration
  def change
    create_table :locale_urls do |t|
      t.string :url
      t.string :language

      t.timestamps null: false
    end
  end
end
