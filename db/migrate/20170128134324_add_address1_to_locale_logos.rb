class AddAddress1ToLocaleLogos < ActiveRecord::Migration
  def change
    add_column :locale_logos, :address1, :string
    add_column :locale_logos, :address2, :string
    add_column :locale_logos, :email, :string
    add_column :locale_logos, :phone_number, :string
    add_column :locale_logos, :title, :string
    add_column :locale_logos, :copyright, :string
  end
end
