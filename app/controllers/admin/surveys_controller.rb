class Admin::SurveysController < AdminController

  def new
    set_subject
    new_survey
    new_question
  end

  def edit
    set_subject
    set_survey
  end

  def create
    set_subject
    @survey = @subject.surveys.new(survey_params)
    if @survey.valid? && @survey.save
      redirect_to admin_survey_subject_path(@subject), notice: 'You have created a new survey module'
    else
      render action: :new
    end
  end

  def update
    set_subject
    set_survey
    if @survey.update_attributes(survey_params)
      redirect_to admin_survey_subject_path(@subject), notice: 'You have updated a survey module'
    else
      render action: :edit
    end
  end

  def destroy
    set_subject
    set_survey
    @survey.destroy
    redirect_to admin_survey_subject_path(@subject), notice: 'You have successfully deleted a survey module'
  end

  private

  def set_subject
    @subject ||= SurveySubject.find(params[:survey_subject_id])
  end

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end
  
  def new_survey
    @survey = @subject.surveys.new
  end

  def new_question
    @survey.questions.build
  end

  def survey_params
    params.require(:survey_survey).permit(:weight, :name, :description, :finished, :active, :attempts_number, {:questions_attributes=>[:text, :survey, {:options_attributes=>[:text, :correct, :weight, :id, :_destroy]}, :id, :_destroy]}, :id, :_destroy)
  end
end
