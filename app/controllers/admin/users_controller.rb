class Admin::UsersController < AdminController

    def index
        @users ||= User.all
        @users = @users.name_like(params[:name]) unless params[:name].nil?
        @users = @users.email_like(params[:email]) unless params[:email].nil?
        @users = @users.by_role(params[:role]) unless params[:role].nil?
        @users = @users.daycare_like(params[:daycare_name]) unless params[:daycare_name].nil?
        @users = @users.by_daycare(params[:daycare_id]) unless params[:daycare_id].nil?
        @users = @users.department_like(params[:department_name]) unless params[:department_name].nil? || params[:department_name].blank?
    end

    def destroy
	    @user = User.find(params[:id])
	    @user.destroy

	    redirect_to admin_users_path, notice: "User deleted."
    end

    def send_verify
        user = User.find(params[:id])
        if user.confirm_token && !user.email_confirmed
            send_confirmation_email(user)        
            respond_to do |format|
              result = {:Result => "OK"}
              format.json { render json: result }
            end
        else
            respond_to do |format|
              result = {:Result => "Failed"}
              format.json { render json: result }
            end
        end
    end

    private

    def set_users
        @users ||= User.all
    end

  def send_confirmation_email user
    #RegistrationMailer.registration_confirmation(user).deliver_later
    host_name = LocaleUrl.find_by(language: I18n.locale.downcase)
    host_url = (host_name.nil?) ? t("mailers.supermanager.url") : host_name.url
    confirm_url = "http://#{host_url}/confirm_email/#{user.confirm_token}"
    @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_VERIFICATION_SUBJECT'], language: I18n.locale.downcase) 
    template_key = 'EMAIL_VERIFICATION_SUBJECT_' + ((user.deposit_required) ? "DEPOSIT" : "REGISTER")
    @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
    @message_template = @sub_subject.message_templates.find_by(target_role: 0, language: I18n.locale.downcase)

    template = @message_template.content.gsub! '[$NAME$]', user.name
    template = template.gsub! '[$EMAIL_VERIFICATION_URL$]', confirm_url

    RegistrationMailer.registration_confirmation(user, template).deliver_now
  end

end