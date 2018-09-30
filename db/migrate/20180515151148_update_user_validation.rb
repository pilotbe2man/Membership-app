class UpdateUserValidation < ActiveRecord::Migration
  def change
  	remove_index :users, column: :email
  	add_index :users, :email, unique: true, where: "(email != '')"
  end
end
