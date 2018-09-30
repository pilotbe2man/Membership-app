class AttemptsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(["parentee", "worker"]) }

  helper :surveys

  def new
    set_subject
    if @subject.nil?
      redirect_to dashboard_path
    end
    set_user
    @pending_checker = SurveyPendingChecker.new
  end

  def create
    set_subject
    set_survey
    normalize_attempts_data
    @attempt = @survey.attempts.new(attempt_params)
    build_remote_survey_answer
    @attempt.participant = current_user
    # @attempt.remote_id = @remote_response.id

    if @attempt.valid? && @attempt.save
      set_attempt_rate
      SurveyPendingOption.where(survey_id: params[:survey_id], user_id: current_user.id).update_all(:completed =>true)

      render json: { last: @survey.id == @subject.surveys.order(weight: :desc).last.id ? true : false }, status: 200
    else
      render json: { }, status: 200
    end
  end

  private

  def set_subject
    @subject ||= SurveySubject.find(params[:subject_id])
  end

  def set_user
    @participant = current_user
  end

  def set_survey
    @survey ||= Survey::Survey.find(params[:survey_id])
  end

  def normalize_attempts_data
    normalize_data!(params[:survey_attempt][:answers_attributes])
  end

  def normalize_data!(hash)
    multiple_answers = []
    last_key = hash.keys.last.to_i

    hash.keys.each do |k|
      if hash[k]['option_id'].is_a?(Array)
        if hash[k]['option_id'].size == 1
          hash[k]['option_id'] = hash[k]['option_id'][0]
          next
        else
          multiple_answers <<  k if hash[k]['option_id'].size > 1
        end
      end
    end

    multiple_answers.each do |k|
      hash[k]['option_id'][1..-1].each do |o|
        last_key += 1
        hash[last_key.to_s] = hash[k].merge('option_id' => o)
      end
      hash[k]['option_id'] = hash[k]['option_id'].first
    end
  end

  def attempt_params
    params.require(:survey_attempt).permit(Survey::Attempt::AccessibleAttributes)
  end

  def build_remote_survey_answer
    answer = {}
    @attempt.answers.each do |ans|
      answer_key = "[#{ans.question.remote_id}][#{ans.option.remote_id}]"
      answer[answer_key] = ans.option.text
    end
    # @remote_response = ResponseEx.create(survey_id: @subject.remote_id, data: answer)
  end

  def set_attempt_rate
    survey_id = @attempt.survey.id
    attempt_id = @attempt.id
    total_count = Survey::Answer.joins("LEFT JOIN survey_questions AS q ON q.id = survey_answers.question_id")
                                .where("q.survey_id = #{survey_id} AND survey_answers.attempt_id = #{attempt_id}")
                                .select("survey_answers.id")
                                .count
    correct_count = Survey::Answer.joins("LEFT JOIN survey_questions AS q ON q.id = survey_answers.question_id")
                                .where("q.survey_id = #{survey_id} AND survey_answers.attempt_id = #{attempt_id} AND survey_answers.correct = true")
                                .select("survey_answers.id")
                                .count
    unless @attempt.nil?
      @attempt.rate = (correct_count.to_f / total_count.to_f) * 100.0
      @attempt.save
    end
  end
end
