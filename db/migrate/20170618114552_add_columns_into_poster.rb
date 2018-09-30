class AddColumnsIntoPoster < ActiveRecord::Migration
  def change
  	add_column :locale_posters, :title, :string
  	add_column :locale_posters, :button, :string
  end
end
