class CreateIllnessGuides < ActiveRecord::Migration
  def change
    create_table :illness_guides do |t|
      t.integer :illness_id
      t.string :content
      t.string :language
      t.string :ref_id
      t.integer :target_role

      t.timestamps null: false
    end
  end
end
