class Api::MessageTemplatesController < ApiController

  def filter_by
    get_subject
    get_sub_subject
    get_message_template
    data = format_json_data

    render json: data, status: 200
  end

  private

  def get_subject
    @subject = MessageSubject.find(params[:subject_id])
  end

  def get_sub_subject
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id])
  end

  def get_message_template
    if @subject && @sub_subject
      @message_template = @sub_subject.message_templates.active.for_role(params[:target_role])
    end
  end

  def format_json_data
    data = {}
    data[:subject_title] = @subject.title if @subject
    data[:sub_subject_title]= @sub_subject.title if @sub_subject

    data.merge!(message_template_id: @message_template.id,
                message_template_content: @message_template.content,
                target_role: @message_template.target_role.humanize
               ) if @message_template

    data
  end

end
