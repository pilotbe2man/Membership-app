class AddParterUrlField < ActiveRecord::Migration
  def change
    add_column :affiliates, :url, :string
  end
end
