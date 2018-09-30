class AddAppTitleToLocalLogos < ActiveRecord::Migration
  def change
    add_column :locale_logos, :app_title, :string
  end
end
