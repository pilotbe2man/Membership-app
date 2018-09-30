class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :discussion, index: true
      t.references :owner, index: true
      t.string     :content

      t.datetime   :deactivated_at
      t.timestamps null: false
    end
  end
end
