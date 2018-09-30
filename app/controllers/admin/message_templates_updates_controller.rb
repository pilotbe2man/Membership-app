class Admin::MessageTemplatesUpdatesController < AdminController
  before_filter :set_message_template, only: [:edit, :update, :destroy]

  def index
    @templates = MessageTemplate.all
  end

  def new
    @template = MessageTemplate.new
  end

  def create
    set_subject
    set_sub_subject
    @template = @sub_subject.message_templates
                .build(message_template_params.merge(sub_subject_id: @sub_subject.id))
    if @template.save
      redirect_to admin_message_templates_updates_path, notice: t('messages.notifications.create_template_success')
    else
      redirect_to new_admin_message_templates_update_path, notice: t('messages.notifications.create_template_error')+@template.errors.full_messages.join(",")
    end
  end

  def edit
  end


  def update
    set_message_template
    set_subject
    set_sub_subject

    if @template.update(message_template_params.merge(sub_subject_id: @sub_subject.id))
      redirect_to admin_message_templates_updates_path, notice: t('messages.notifications.update_template_success')
    else
      render :edit
    end
  end


  def destroy
    set_message_template
    @template.destroy

    redirect_to admin_message_templates_updates_path, notice: t('messages.notifications.delete_template_success')
  end


  private

  def set_subject
    @subject = MessageSubject.find_or_create_by!(title: params[:subject_title], language: params[:message_template][:language])
  end

  def set_sub_subject
    @sub_subject = MessageSubject.find_or_create_by!(parent_subject_id: @subject.id, title: params[:sub_subject_title], language: params[:message_template][:language])
  end

  def set_message_template
    @template = MessageTemplate.find params[:id]
  end

  def message_template_params
    params.require(:message_template).permit(
      :target_role,
      :language,
      :content
    )
  end

  def get_all_main_subjects
    @subjects = MessageSubject.main_subjects
  end

end
