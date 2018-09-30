class Manager::MessagesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['manager'])}

  def select_department
    set_departments
  end

  def recipient
    @email_list_template = LocaleFile.where(elem_type: 0, language_short_name: I18n.locale.downcase).first
  end

  def subject
    if request.post?
      current_user.message_invite_emails.where(department: params[:department], role: params[:target_role]).where.not(email: params[:email]).delete_all
      params[:email].each do |email|
        if email.present?
          begin
            mie = MessageInviteEmail.new
            mie.email = email
            mie.department = params[:department]
            mie.role = params[:target_role]
            current_user.message_invite_emails << mie
          rescue
          end
        end
      end
    end

    set_subjects
    if @subjects.nil?
      redirect_to '/dashboard'
    end
  end

  def sub_subject
    set_subject
    set_sub_subjects
    if @sub_subjects.nil?
      redirect_to '/dashboard'
    end
  end

  def content
    find_message_template

    if @message_template
      @message = Message.new

      render :new
    else
      redirect_to manager_messages_path, notice: t('messages.notifications.find_template_empty')
    end
  end

  def create
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      MessageNotificationJob.perform_now(@message, target_department: params[:target_department], target_role:  message_params[:target_roles][0])
      notice = t('messages.notifications.send_message_success')
    else
      notice = t('messages.notifications.send_message_error')
    end

    redirect_to manager_messages_path, notice: notice
  end

  def list
    set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    else
      render '/messages/list'
    end
  end

  private

  def set_departments
    @departments ||= current_user.daycare.departments
  end

  def set_subjects
    @subjects ||= MessageSubject.main_subjects.where(language: I18n.locale.downcase)
  end

  def set_subject
    @subject = MessageSubject.find params[:subject_id] if (params[:subject_id].present?)
  end

  def set_sub_subjects
    ids = MessageTemplate.pluck(:sub_subject_id).uniq
    @sub_subjects = @subject.sub_subjects.where(id: ids) if @subject.present?
  end

  def set_sub_subject
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id]) if @subject && params[:sub_subject_id].present?
  end

  def find_message_template
    set_subject
    set_sub_subject

    if @subject && @sub_subject && params['target_role'].present?
      @message_template = @sub_subject.message_templates.for_role params['target_role']
    end
  end

  def message_params
    params.require(:message).permit(
      :message_template_id,
      :title,
      :content,
      target_roles: []
    )
  end


  def set_messages
    find_message_template

    cond_str, cond_arr = set_query_conditions

    @messages ||= Message.where(cond_str, *cond_arr)
                .order(created_at: :desc)
                .page(params[:page])
  end

  def set_query_conditions
    cond_str = []
    cond_arr = []

    if params['list_type'] == 'sent'
      cond_str << 'owner_id = ?'
      cond_arr << current_user.id

      if params['target_role']
        cond_str << '? = ANY (target_roles)'
        cond_arr << params['target_role']
      end
    else
      notifs = current_user.notifications.by_source_type('Message')
      msg_ids = if params['target_role'].present?
                  notifs.map(&:source)
                    .select{|msg_source| msg_source.owner.role == params['target_role']}
                    .map(&:id)
                else
                  notifs.map(&:source)
                    .map(&:id)
                end

      msg_ids = msg_ids.reject{|msg_id| msg_id == @notification.source_id} if @notification.present?

      cond_str << 'id IN (?)'
      cond_arr << msg_ids
    end

    if @message_template.present?
      cond_str << 'message_template_id = ?'
      cond_arr << @message_template.id
    end

    if params['start_date'].present?
      cond_str << 'created_at >= ?'
      cond_arr << Date.parse(params['start_date']) - 1
    end

    if params['end_date'].present?
      cond_str << 'created_at <= ?'
      cond_arr << Date.parse(params['end_date']) + 1
    end

    [cond_str.join(' AND '), cond_arr]
  end

end
