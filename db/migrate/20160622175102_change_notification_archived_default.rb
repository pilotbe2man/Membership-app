class ChangeNotificationArchivedDefault < ActiveRecord::Migration
  def change
    change_column_default :notifications, :archived, false
  end
end
