class AddTrialEndDateToUsers < ActiveRecord::Migration
    def change
        add_column :users, :trial_end_date, :datetime
    end
end
