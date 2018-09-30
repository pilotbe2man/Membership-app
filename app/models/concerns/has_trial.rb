module HasTrial
    extend ActiveSupport::Concern

    included do
        after_create :assign_trial_end_date
    end

    # => After creating a new user, set the trial_end_date to 2 weeks from now
    #
    def assign_trial_end_date
        self.trial_end_date = 2.weeks.from_now
        save!
    end
end