class AddGuideToIllnesses < ActiveRecord::Migration
  def change
    change_table :illnesses do |t|
      t.attachment :worker_guide
      t.attachment :parent_guide
    end
  end
end
