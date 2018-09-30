class CreateMessageTemplates < ActiveRecord::Migration
  def change
    create_table :message_templates do |t|
      t.references :sub_subject, index: true
      t.integer    :target_role
      t.string     :content
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
