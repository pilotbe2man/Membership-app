class AddMunicipalIdToDaycare < ActiveRecord::Migration
  def change
    add_column :daycares, :municipal_id, :integer
    add_column :affiliates, :municipal_id, :integer
  end
end
