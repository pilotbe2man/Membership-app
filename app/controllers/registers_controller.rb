class RegistersController < ApplicationController
  layout "register"
  def index
    @user = MeetingUser.new
  end

  def create
    @user = MeetingUser.where(email: permit_params[:email]).first
    if @user.nil?
      @user = MeetingUser.new(permit_params)
      @user.token = Devise.friendly_token      
    end

    if @user.save
      send_confirmation_email @user
      redirect_to webinar_calendar_path({ name: @user.name, email: @user.email })
    else
      render text: "Error: #{@user.errors.full_messages.join(", ")}"
    end
  end

  private
    def permit_params
      params.require(:meeting_user).permit(:name, :daycare_name, :mobile, :email)
    end

    def send_confirmation_email user
      #RegistrationMailer.registration_confirmation(user).deliver_later
      host_name = LocaleUrl.find_by(language: I18n.locale.downcase)
      host_url = (host_name.nil?) ? t("mailers.supermanager.url") : host_name.url
      confirm_url = "http://#{host_url}/account_register?token=#{user.token}"

      @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_VERIFICATION_SUBJECT'], language: I18n.locale.downcase) 
      template_key = 'EMAIL_VERIFICATION_SUBJECT_DEPOSIT'
      @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
      @message_template = @sub_subject.message_templates.find_by(target_role: 0, language: I18n.locale.downcase)

      template = @message_template.content.gsub! '[$NAME$]', user.name
      template = template.gsub! '[$EMAIL_VERIFICATION_URL$]', confirm_url

      RegistrationMailer.registration_confirmation(user, template).deliver_now
    end
end
