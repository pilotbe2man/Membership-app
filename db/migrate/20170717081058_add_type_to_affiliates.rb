class AddTypeToAffiliates < ActiveRecord::Migration
  def change
    add_column :affiliates, :affiliate_type, :integer, default: 0
  end
end
