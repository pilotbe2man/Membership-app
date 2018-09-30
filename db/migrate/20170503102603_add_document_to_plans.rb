class AddDocumentToPlans < ActiveRecord::Migration
  def change
    change_table :plans do |t|
      t.attachment :document
    end
  end
end
