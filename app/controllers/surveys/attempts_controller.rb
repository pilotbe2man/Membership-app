class Surveys::AttemptsController < ApplicationController
  # before_action -> { authenticate_role!(["parentee", "worker"]) }

  helper :surveys

  def new
    set_survey
    @participant = current_user # you have to decide what to do here

    unless @survey.nil?
      @attempt = @survey.attempts.new
      @attempt.answers.build
    end
  end

  def create
    set_survey
    normalize_attempts_data
    @attempt = @survey.attempts.new(attempt_params)
    @attempt.participant = current_user

    if @attempt.valid? && @attempt.save
      redirect_to surveys_path, notice: "You have completed the survey #{@survey.name} survey!"
    else
      render action: :new
    end
  end

  private

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
end
