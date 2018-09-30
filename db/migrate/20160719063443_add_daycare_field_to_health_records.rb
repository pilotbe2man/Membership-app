class AddDaycareFieldToHealthRecords < ActiveRecord::Migration
  def change
    add_column :health_records, :daycare_id, :integer
  end
end
