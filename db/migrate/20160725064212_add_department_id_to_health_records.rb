class AddDepartmentIdToHealthRecords < ActiveRecord::Migration
  def change
    add_column :health_records, :department_id, :integer
  end
end
