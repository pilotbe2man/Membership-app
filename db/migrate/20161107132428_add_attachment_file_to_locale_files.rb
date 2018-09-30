class AddAttachmentFileToLocaleFiles < ActiveRecord::Migration
  def self.up
    change_table :locale_files do |t|
      t.attachment :file
      t.attachment :online_training
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :locale_files, :file
    remove_attachment :locale_files, :online_training
    remove_attachment :locale_files, :logo
  end
end
