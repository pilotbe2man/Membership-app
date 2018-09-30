class CreateUserOccurrences < ActiveRecord::Migration
  def change
    create_table :user_occurrences do |t|
      t.integer :user_id
      t.integer :todo_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
