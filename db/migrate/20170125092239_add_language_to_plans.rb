class AddLanguageToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :plan_type, :integer
    add_column :plans, :language, :string
  end
end
