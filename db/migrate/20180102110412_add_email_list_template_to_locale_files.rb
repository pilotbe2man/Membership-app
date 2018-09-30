class AddEmailListTemplateToLocaleFiles < ActiveRecord::Migration
  def self.up
    change_table :locale_files do |t|
      t.attachment :email_list_template
      t.integer :elem_type
    end
  end

  def self.down
    remove_attachment :locale_files, :email_list_template
  end
end
