class AddNumMemberToAffiliates < ActiveRecord::Migration
  def change
    add_column :affiliates, :num_member, :integer, default: 0
  end
end
