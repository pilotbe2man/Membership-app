class AddCareTypeColumnToDaycares < ActiveRecord::Migration
  def change
    add_column :daycares, :care_type, :integer
  end
end
