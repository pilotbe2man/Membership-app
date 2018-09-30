class SurveyPendingOptionController < ApplicationController
    def new
    	@pending_option = SurveyPendingOption.where(survey_id: params[:survey_id], 
    												question_id: params[:question_id], 
    												user_id: params[:user_id]).destroy_all
    	@pending_option = SurveyPendingOption.new
    	@pending_option.survey_id = params[:survey_id]
    	@pending_option.question_id = params[:question_id]
    	@pending_option.option_id = params[:option_id]
    	@pending_option.user_id = params[:user_id]
    	@pending_option.subject_id = params[:subject_id]    	
    	@pending_option.completed = false
    	if @pending_option.save
    		render json: { result: 'OK' }, status: 200
    	else
    		render json: { result: 'Failed' }, status: 200
    	end
    end	

    def complete
    	SurveyPendingOption.where(user_id: params[:user_id], subject_id: params[:subject_id]).destroy_all
    	redirect_to results_subjects_path(subject_id: params[:subject_id])
    end
end
