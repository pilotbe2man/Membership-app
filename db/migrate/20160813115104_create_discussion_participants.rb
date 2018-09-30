class CreateDiscussionParticipants < ActiveRecord::Migration
  def change
    create_table :discussion_participants do |t|
      t.references :discussion, index: true
      t.references :participant, polymorphic: true
      t.boolean    :initiator
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
