class AddLanguagesColumnToLocaleFile < ActiveRecord::Migration
  def change
    add_column :locale_files, :language_name, :string
    add_column :locale_files, :language_short_name, :string
  end
end
