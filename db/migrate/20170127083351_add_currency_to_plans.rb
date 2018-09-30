class AddCurrencyToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :currency, :string
  end
end
