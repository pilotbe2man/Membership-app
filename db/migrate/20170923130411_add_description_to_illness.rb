class AddDescriptionToIllness < ActiveRecord::Migration
  def change
    add_column :illnesses, :description, :string
  end
end
