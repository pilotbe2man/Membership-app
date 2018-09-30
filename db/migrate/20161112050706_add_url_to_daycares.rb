class AddUrlToDaycares < ActiveRecord::Migration
  def change
  	add_column :daycares, :url, :string
  	add_column :daycares, :num_children, :integer
  	add_column :daycares, :num_worker, :integer
  end
end
