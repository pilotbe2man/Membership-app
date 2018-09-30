class RemoveDaycareIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :daycare_id
  end
end
