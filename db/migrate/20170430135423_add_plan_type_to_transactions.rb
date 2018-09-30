class AddPlanTypeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :plan_type, :integer, default: 0
  end
end
