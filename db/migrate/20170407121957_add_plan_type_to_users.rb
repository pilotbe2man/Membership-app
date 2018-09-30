class AddPlanTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan_type, :integer
  end
end
