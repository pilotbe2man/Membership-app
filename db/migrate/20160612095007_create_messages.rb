class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :message_template, index: true
      t.integer    :target_role
      t.integer    :owner_id
      t.string     :title
      t.string     :content
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
