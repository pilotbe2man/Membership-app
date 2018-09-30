class PlanMailer < ApplicationMailer
    default template_path: 'mailers/plan'

    def send_confirmation user
        @user = user
        @plan = user.plan
        mail(to: @user.email, 
            subject: "You have successfully upgraded your account"
        )
    end

    def send_reminder user
        @user = user
        # send the user multiple reminders for an upgrade?
        # if above true, increment upgrade reminder?
        mail(to: @user.email, 
            subject: 'You still have time to upgrade'
        )
    end
end