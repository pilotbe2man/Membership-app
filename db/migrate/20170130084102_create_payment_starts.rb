class CreatePaymentStarts < ActiveRecord::Migration
  def change
    create_table :payment_starts do |t|
      t.integer :period
      t.string :unit

      t.timestamps null: false
    end
    add_column :daycares, :payment_start_id, :integer
    add_column :locale_logos, :upgrade_notifier, :string
    add_column :locale_logos, :invitation_notifier, :string
  end
end
