class AddLanguageColumnToMessageTemplate < ActiveRecord::Migration
  def change
    add_column :message_templates, :language, :string
  end
end
