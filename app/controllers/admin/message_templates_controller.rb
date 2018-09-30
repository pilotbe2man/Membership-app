class Admin::MessageTemplatesController < AdminController

  def create
    set_subject
    set_sub_subject
    @template = @sub_subject.message_templates
                .build(message_template_params.merge(sub_subject_id: @sub_subject.id))
    build_template_from_docx
    if @template.save
      redirect_to admin_message_templates_path, notice: t('messages.notifications.create_template_success')
    else
      redirect_to new_admin_message_template_path, notice: t('messages.notifications.create_template_error')
    end
  end

  def new
    @template = MessageTemplate.new
  end

  def edit_filters
    get_all_main_subjects
  end

  def show
    set_message_template
  end

  def edit
    unless params[:type].blank?
      @subject = MessageSubject.find(params[:subject])
      template_key = ''
      if params[:type] == 'verify'
        case params[:sub_type]
        when 'deposit'
          template_key = 'EMAIL_VERIFICATION_SUBJECT_DEPOSIT'
        when 'register'
          template_key = 'EMAIL_VERIFICATION_SUBJECT_REGISTER'
        end
        @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
        @template = @sub_subject.message_templates.find_or_create_by(target_role: 0, :language => @subject.language.downcase)
      else
        case params[:sub_type]
        when 'worker'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_WORKER'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 1, :language => @subject.language.downcase)
        when 'parentee'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_PARENTEE'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 0, :language => @subject.language.downcase)
        when 'manager'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_MANAGER'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 2, :language => @subject.language.downcase)
        when 'internal'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_INTERNAL'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 3, :language => @subject.language.downcase)
        when 'external'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_EXTERNAL'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 4, :language => @subject.language.downcase)
        when 'contact'
          template_key = 'SURVEY_TEMPLATE_SUBJECT_CONTACT'
          @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], :language => @subject.language.downcase)
          @template = @sub_subject.message_templates.find_or_create_by(target_role: 5, :language => @subject.language.downcase)
        end
      end
    else
      set_message_template
    end
  end

  def update
    set_message_template

    if @template.update(message_template_params)
      redirect_to admin_root_path, notice: t('messages.notifications.update_template_success')
    else
      render :edit
    end
  end

  def destroy
    set_message_template
    @template.deactivate!

    redirect_to admin_message_templates_path, notice: t('messages.notifications.delete_template_success')
  end

  def filter
    find_template_by_filters

    if @template.present?
      redirect_to admin_message_template_path(@template)
    else
      redirect_to edit_filters_admin_message_templates_path, notice: t('messages.notifications.find_template_empty')
    end

  end

  def upload
    if request.post?
      build_template_from_spreadsheet
    end
  end

  private

  def set_subject
    @subject = MessageSubject.find_or_create_by(title: params[:subject_title])
  end

  def set_sub_subject
    @sub_subject = @subject.sub_subjects.create(title: params[:sub_subject_title])
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

  def find_template_by_filters
    @subject = MessageSubject.find(params[:subject_id]) if params[:subject_id].present?
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id]) if @subject && params[:sub_subject_id].present?

    @template = @sub_subject.message_templates.active.for_role(params[:target_role]) if @sub_subject && params[:target_role]
  end

  def build_template_from_docx
    file_data = params[:upload_template]
    if file_data
      doc = Docx::Document.open(file_data.path)
      # Retrieve and display paragraphs
      content = '';
      doc.paragraphs.each do |p|
        content += p.to_html
      end    

      puts content
      @template.content = content
    end
  end

  def build_template_from_spreadsheet
    file_data = params[:spreadsheet_file]

    if file_data
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          2.upto(xlsx.last_row) do |line|
            @subject = MessageSubject.find_or_create_by(title: xlsx.cell(line, 'A')) if xlsx.cell(line, 'A')
            @sub_subject = @subject.sub_subjects.create(title: xlsx.cell(line, 'B')) if xlsx.cell(line, 'B')
            template = @sub_subject.message_templates.create(target_role: xlsx.cell(line, 'C').downcase, language: params[:template_lang].downcase, content: xlsx.cell(line, 'D'))
          end        
        end
      end
    end
  end

end
