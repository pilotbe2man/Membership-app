class RegistrationMailerPreview < ActionMailer::Preview

    def send_confirmation
        set_user
        RegistrationMailer.send_confirmation(@user)
    end

    private

    def set_user
        @user = User.manager.first
    end
end