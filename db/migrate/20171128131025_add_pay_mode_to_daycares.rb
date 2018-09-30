class AddPayModeToDaycares < ActiveRecord::Migration
  def change
    add_column :daycares, :pay_mode, :integer, default: 1
  end
end
