class CreateIllnessGuideUpdates < ActiveRecord::Migration
  def change
    create_table :illness_guide_updates do |t|
      t.string :title
      t.string :description
      t.timestamps null: false
    end
  end
end
