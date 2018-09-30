module MessagesHelper
  def options_for_sub_subject_select
    @subject.sub_subjects
      .flatten
      .map{|sub| [sub.title, sub.id, {'data-parent_id': sub.parent_subject_id}]}
  end

  def options_for_message_recipients_select
    Message.allowed_recipients_for_role(current_user.role).collect{|m| [t('pages.nav_bar.'+m).humanize.pluralize, m]}
  end

  def options_for_message_senders_select
    Message.allowed_senders_for_role(current_user.role).map{|role| [t('pages.nav_bar.'+role).humanize.pluralize, role]}
  end

  def options_for_template_localizations
    SUPPORTED_LOCALES.map{|k, v| [v, k]}
  end

  def edit_template_header
    t('messages.breadcrumb.edit_template') + ' :'
  end

  def add_subject_header
    "#{t('messages.breadcrumb.message')} > " +
      "#{t('messages.breadcrumb.create_subject')}"
  end

  def add_sub_subject_header
    add_subject_header +
      " > " +
      "#{t('messages.breadcrumb.create_sub_subject')}"
  end

  def add_recipient_header
    add_sub_subject_header +
      " > " +
      "#{t('messages.breadcrumb.choose_recipient')}"
  end

  def add_template_content_header
    add_recipient_header +
      " > " +
      "#{t('messages.breadcrumb.add_content')}"
  end

  def choose_department_header
    "#{t('messages.breadcrumb.message_options')} > " +
      "#{t('messages.breadcrumb.choose_department')}"
  end

  def choose_recipient_header
    choose_department_header +
      " > " +
      "#{t('messages.breadcrumb.choose_recipient')}"
  end

  def choose_subject_header
    choose_recipient_header +
      " > " +
      "#{t('messages.breadcrumb.choose_subject')}"
  end

  def choose_sub_subject_header
    choose_subject_header +
      " > " +
      "#{t('messages.breadcrumb.choose_sub_subject')}"
  end

  def create_message_from_template_header
    choose_department_header +
      " > .. > " +
      "#{t('messages.breadcrumb.send')}"
  end

  def progress_bar_step(page_step, form_step)
    page_step > form_step ? 'complete' : page_step == form_step ? 'active' : 'disabled'
  end

  def message_role_label
    params[:list_type] == 'received' ? I18n.t('messages.labels.sender') : I18n.t('messages.labels.recipient')
  end

  def message_role_value(message)
    params[:list_type] == 'received' ? message.owner.name : message.target_roles.map(&:humanize).join(', ')
  end

end
