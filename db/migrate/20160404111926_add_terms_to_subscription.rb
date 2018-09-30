class AddTermsToSubscription < ActiveRecord::Migration
    def change
        add_column :subscriptions, :terms, :boolean, default: false
    end
end
