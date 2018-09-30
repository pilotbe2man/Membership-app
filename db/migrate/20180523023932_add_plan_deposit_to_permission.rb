class AddPlanDepositToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :plan_deposit, :integer, default: 0
  end
end
