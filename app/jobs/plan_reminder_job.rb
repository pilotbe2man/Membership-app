class PlanReminderJob < ActiveJob::Base
    queue_as :default

    def perform *args
        set_valid_users
        @users.each do |user|
            next unless user.reminder_user?
            PlanMailer.send_reminder(user).deliver_now
        end
    end

    private

    def set_valid_users
        @users ||= User.manager.unsubscribed
    end 
end