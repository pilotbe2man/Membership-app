class AddTokenToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :token, :string, unique: true
  end
end
