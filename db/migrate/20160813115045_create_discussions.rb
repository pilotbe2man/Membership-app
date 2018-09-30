class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string     :title
      t.references :subject, polymorphic: true, index: true
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
