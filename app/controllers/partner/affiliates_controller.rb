class Partner::AffiliatesController < ApplicationController
  layout 'registration'
  before_action -> { authenticate_role!(["partner"]) }, only: [:invite_member]

  def invite_member
    @member_type = params[:type]

    @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT'], language: I18n.locale.downcase) 
    template_key = 'SURVEY_TEMPLATE_SUBJECT_' + @member_type.upcase
    @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
    @message_template = @sub_subject.message_templates.find_by(target_role: MessageTemplate.target_roles[@member_type.downcase], language: I18n.locale.downcase)
  rescue => e
    redirect_to dashboard_path
  end
  
  def send_invite_member    
    email_list = []

    file_data = params[:email_address]
    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          2.upto(xlsx.last_row) do |line|
            unless (xlsx.cell(line, 'A').nil?)
              email_list << xlsx.cell(line, 'A')
            end
          end
        end
      end
    end

    email_list << params[:email]

    if current_user.nil?
      ManagerInviteEmailJob.perform_now(email_list, params[:title], params[:content], current_user.email, current_user.name)      
    else
      ManagerInviteEmailJob.perform_now(email_list, params[:title], params[:content], current_user.email, current_user.name)      
    end

    redirect_to dashboard_path, notice: "Successfully sent your invites"
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      target_roles: []
    )
  end
end