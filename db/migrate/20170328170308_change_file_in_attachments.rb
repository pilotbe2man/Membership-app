class ChangeFileInAttachments < ActiveRecord::Migration
  def up
  	remove_column :attachments, :file

    change_table :attachments do |t|
      t.attachment :file
    end
  end

  def down
    change_table :attachments do |t|
      t.remove :file
    end

  	add_column :attachments, :file
  end
end
