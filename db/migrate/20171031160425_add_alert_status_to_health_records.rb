class AddAlertStatusToHealthRecords < ActiveRecord::Migration
  def change
    add_column :health_records, :alert_status, :integer, default: 0
  end
end
