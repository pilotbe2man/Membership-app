class PlanMailerPreview < ActionMailer::Preview

    def send_confirmation
        set_user
        set_subscription
        PlanMailer.send_confirmation(@user)
    end

    def send_reminder
        set_user
        PlanMailer.send_reminder(@user)
    end

    private

    def set_user
        @user = User.manager.first
    end

    def set_subscription
        plan = Plan.first
        plan.subscriptions.create(user_id: @user.id)
    end
end