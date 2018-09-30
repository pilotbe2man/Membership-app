module HasSubscription
    extend ActiveSupport::Concern

    included do
        #has_many :subscriptions
        has_many :transactions

        scope :subscribed,                      -> { includes(:subscriptions).where.not(subscriptions: { id: nil, transaction_id: nil } ) }
        scope :unsubscribed,                    -> { includes(:subscriptions).where(subscriptions: { id: nil } ) }

        # => Checks if a user has an active subscription
        #        
        def subscribed?
            preminum? ? true : false
#            if active_trial? 
#                return false
#            else
#                total_month = subscriptions.where('transaction_id > 0').sum(:month)
#                first_subscription = subscriptions.where('transaction_id > 0').order(:created_at).first
#                if total_month == 0 || first_subscription.nil? || (first_subscription.created_at.to_date <= total_month.to_i.months.ago.to_date)                
#                    return false
#                else
#                    return true
#                end
#            end
        end

        # => Checks if a user has an only active subscription 
        #
        def active_subscribed?
            result = false
            if manager?
                result = preminum? ? true : false
            elsif worker? || parentee?
                daycare.managers.each do |item|
                    if item.active_subscribed?
                        result = true
                    end
                end
            else
                result = true
            end
            return result
            #subscriptions.empty? ? false : true
        end

        # => Checks if a user has an active trial
        #
        def active_trial?
            trial_end_date > Time.now ? true : false
        end

        # => Checks if a user does not have an active subscription
        #
        def unsubscribed?
            preminum? ? false : true
            #subscribed? ? false : true
        end

        # => Checks if a user is valid for a reminder email if they have not yet subscribed yet
        #
        def reminder_user?
            self.created_at.to_date === 3.days.ago.to_date ? true : false
        end

        # => Checks if user is within first n users (used for discount code FIRST100 logic)
        #
        def within_first? counter
            User.manager.count <= counter ? true : false
        end

        def preminum?
            transactions.empty? ? false : true
        end

        def manager_plan_type
            plan_type = daycare.managers.first.plan_type
            if self.is_trial_member? || plan_type == 1
                return 4
            else
                return (plan_type.nil? || plan_type == 0) ? 2 : plan_type
            end            
        end

        def manager_is_non_paid?
            return !daycare.managers.first.is_trial_member? && (!daycare.managers.first.active_subscribed?)
        end
    end
end