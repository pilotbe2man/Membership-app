class Manager::DaycaresController < ApplicationController
  layout 'registration'
  before_action -> { authenticate_role!(["manager"]) }

  def invite_survey
    @daycare_role = params[:type]

    @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT'], language: I18n.locale.downcase) 
    template_key = 'SURVEY_TEMPLATE_SUBJECT_' + @daycare_role.upcase
    @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
    @message_template = @sub_subject.message_templates.find_by(target_role: MessageTemplate.target_roles[@daycare_role.downcase], language: I18n.locale.downcase)
    @email_list_template = LocaleFile.where(elem_type: 0, language_short_name: I18n.locale.downcase).first
  end
  
  def invite
    @message = Message.new(owner_id: current_user.id)
  end

  def send_invite_survey
    email_list = build_emails_from_spreadsheet
    unless params[:email].nil?
      email_list = email_list + params[:email]
      email_list = email_list.uniq
    end
    unless email_list.nil?  
      email_list.each do |user|
        puts user
        DaycareInviteMailer.invite(user, params[:title], params[:content], current_user.email, current_user.name).deliver_now    
      end
      # ManagerInviteEmailJob.perform_now(email_list, params[:title], params[:content], current_user.email, current_user.name)
      redirect_to dashboard_path, notice: "Successfully sent your invites"
    else
      redirect_to invite_survey_manager_daycares_path, notice: "Failed to sent your invites"
    end
  end

  def send_invites      
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      MessageNotificationJob.perform_now(@message, {:invitation => true})
      DaycareInviteEmailJob.perform_now(@message, {:invitation => true})
      redirect_to dashboard_url, notice: "Successfully sent your invites"
    else
      render "invite"
    end

    #DaycareInviteEmailJob.perform_now(params[:emails].join(','))
    #redirect_to dashboard_url, notice: "Successfully sent your invites"
  end

  private

  def build_emails_from_spreadsheet
    file_data = params[:recipient]
    email_list = []
    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          2.upto(xlsx.last_row) do |line|
            email_list.push xlsx.cell(line, 'A') if xlsx.cell(line, 'A')
          end
        end
      end
    end
    return email_list.uniq
  rescue => e
    return nil
  end

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      target_roles: []
    )
  end
end