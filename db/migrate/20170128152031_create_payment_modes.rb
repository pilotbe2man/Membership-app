class CreatePaymentModes < ActiveRecord::Migration
  def change
    create_table :payment_modes do |t|
      t.integer :period
      t.string :unit

      t.timestamps null: false
    end

    add_column :daycares, :payment_mode_id, :integer
    add_column :subscriptions, :payment_mode_id, :integer
  end
end
