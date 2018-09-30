class CreateChildCollaborators < ActiveRecord::Migration
  def change
    create_table :child_collaborators do |t|
      t.references :child, index: true
      t.references :collaborator, polymorphic: true
      t.datetime   :deactivated_at

      t.timestamps null: false
    end
  end
end
