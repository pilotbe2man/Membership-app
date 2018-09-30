class ChangeTypeColumn < ActiveRecord::Migration
  def up
  	change_column :locale_posters, :poster_type, :string
  end

   def down
  	change_column :locale_posters, :poster_type, :integer
  end
end
