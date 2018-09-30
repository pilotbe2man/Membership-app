class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :source, polymorphic: true
      t.integer    :target_id
      t.boolean    :archived

      t.timestamps null: false
    end
  end
end
