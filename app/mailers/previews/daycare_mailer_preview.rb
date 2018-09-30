class DaycareMailerPreview < ActionMailer::Preview

    def invite
        set_email
        DaycareMailer.invite(@email)
    end

    private

    def set_email
        @email = Faker::Internet.email
    end
end