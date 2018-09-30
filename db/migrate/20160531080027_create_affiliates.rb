class CreateAffiliates < ActiveRecord::Migration
  def change
    create_table :affiliates do |t|
      t.string    :name
      t.string    :address
      t.string    :postcode
      t.string    :country
      t.string    :telephone
      t.datetime  :deactivated_at

      t.timestamps null: false
    end
    add_index :affiliates, :name

    create_table :user_affiliates do |t|
      t.integer  :user_id
      t.integer  :affiliate_id
      t.datetime :deactivated_at

      t.timestamps null: false
    end
    add_index :user_affiliates, :user_id
    add_index :user_affiliates, :affiliate_id
  end


end
