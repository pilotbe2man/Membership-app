class CreateMessageSubjects < ActiveRecord::Migration
  def change
    create_table :message_subjects do |t|
      t.string     :title
      t.references :parent_subject, index: true

      t.timestamps null: false
    end
  end
end
