class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :attachable_id
      t.string :file
      t.string :attachable_type

      t.timestamps null: false
    end
  end
end
