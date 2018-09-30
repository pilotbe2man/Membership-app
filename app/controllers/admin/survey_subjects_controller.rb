class Admin::SurveySubjectsController < AdminController

  def index
    set_subjects
  end

  def show
    set_subject   
  end

  def new
    new_subject
    new_icon_attachment
  end

  def edit
    set_subject
  end

  def create
    @subject = SurveySubject.new(subject_params)
    if @subject.save
      # set_remote_survey
      build_surveys_from_spreadsheet
      redirect_to admin_survey_subject_path(@subject), notice: 'You have created a new subject'
    else
      new_icon_attachment
      render action: :new
    end
  end

  def update
    set_subject
    if @subject.update_attributes(subject_params)
      redirect_to admin_survey_subject_path(@subject), notice: 'You have updated a subject'
    else
      render action: :edit
    end
  end

  def destroy
      set_subject
      # delete_remote_survey      
      @subject.destroy
      redirect_to admin_survey_subjects_path(@subject), notice: 'You have successfully deleted a survey.'
    end

  def upload
    set_subject
    if request.post?
      build_surveys_from_spreadsheet
      redirect_to admin_survey_subject_path(@subject), notice: 'You have successfully uploaded a survey module'
    end
  end

  private

  def new_icon_attachment
    @subject.build_icon
  end

  def set_subject
    @subject ||= SurveySubject.find(params[:id])
  end

  def set_subjects
    @subjects = SurveySubject.all
  end
  
  def new_subject
    @subject = SurveySubject.new
    @ori_survey = SurveySubject.find(params[:survey_id]) unless params[:survey_id].nil?
  end

  def subject_params
    params.require(:survey_subject).permit(:daycare_id, :title, :description, :language, icon_attributes: [:id, :attachable_type, :attachable_id, :file])
  end

  def set_remote_survey
    if @subject.remote_id.nil?
      remote_survey = SurveyGizmo::API::Survey.new
      remote_survey.title = params[:survey_subject][:title]
      remote_survey.type ="survey"
      if remote_survey.save   
        @subject.remote_id = remote_survey.id
        @subject.save
      end
    end
  end

  def delete_remote_survey        
    survey = SurveyGizmo::API::Survey.first(id: @subject.remote_id) unless @subject.remote_id.nil?
    survey.destroy unless survey.nil?
  end

  def build_surveys_from_spreadsheet
    params[:spreadsheet_file].each do |doc| 
      file_data = doc
      xlsx = Roo::Spreadsheet.open(file_data.path, extension: :xlsx)
      survey_name = file_data.original_filename.split('.xlsx').first.titleize
      if xlsx.sheets.count > 0
        if xlsx.last_row > 1
          # remote_subpage = SurveyGizmo::API::Page.create(survey_id: @subject.remote_id, :title => survey_name, :description => "Uploaded survey of #{survey_name}")
          # if remote_subpage.save
            # survey = @subject.surveys.build(name: survey_name, description: "Uploaded survey of #{survey_name}", attempts_number: 100000, active: true, remote_id: remote_subpage.id)
            survey = @subject.surveys.build(name: survey_name, description: "Uploaded survey of #{survey_name}", attempts_number: 100000, active: true, remote_id: 0)
            if survey.save(validate: false)
              2.upto(xlsx.last_row) do |line|
                # remote_question = SurveyGizmo::API::Question.create(survey_id: @subject.remote_id, page_id: remote_subpage.id, :title => xlsx.cell(line, 'A'), type: 'radio') unless xlsx.cell(line, 'A').nil?
                # if remote_question.save
                  # question = survey.questions.new(:text => xlsx.cell(line, 'A'), remote_id: remote_question.id) unless xlsx.cell(line, 'A').nil?
                  question = survey.questions.new(:text => xlsx.cell(line, 'A'), remote_id: 0) unless xlsx.cell(line, 'A').nil?
                  if question.present? && question.save!
                    options = []
                    options << question.options.new(:text => xlsx.cell(line, 'B').to_s, :weight => 1, :correct => false) unless xlsx.cell(line, 'B').nil?
                    options << question.options.new(:text => xlsx.cell(line, 'C').to_s, :weight => 1, :correct => false) unless xlsx.cell(line, 'C').nil?
                    options << question.options.new(:text => xlsx.cell(line, 'D').to_s, :weight => 1, :correct => false) unless xlsx.cell(line, 'D').nil?
                    options << question.options.new(:text => xlsx.cell(line, 'E').to_s, :weight => 1, :correct => false) unless xlsx.cell(line, 'E').nil?
                    answer = xlsx.cell(line, 'F').to_s unless xlsx.cell(line, 'F').nil?
                    options.each{|op| op.correct = true if op.text.strip.downcase == answer.strip.downcase} if options.count > 0 && answer.present?
                    if options.count > 0
                      options.each do |op|
                        # remote_option = SurveyGizmo::API::Option.create(survey_id: @subject.remote_id, page_id: remote_subpage.id, question_id: remote_question.id, :value => op.text, :title => op.text)
                        # if remote_option.save
                          # op.remote_id = remote_option.id
                          op.remote_id = 0
                          op.save!
                        # end
                      end
                    end
                  end
                # end
              end
            end
          # end
        end
      end
    end
  end
end