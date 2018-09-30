class ChangeDecimalToIntegerOnDiscountCode < ActiveRecord::Migration
    def change
        change_column :discount_codes, :value, :integer, default: 0
    end
end
