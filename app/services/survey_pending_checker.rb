class SurveyPendingChecker
	def is_pending_option?(option_id, user_id)
		pending_option = SurveyPendingOption.where(user_id: user_id, option_id: option_id).first
		if pending_option.nil? || pending_option.completed == true
			false
		else
			true
		end			
	end

	def survey_pending_id(user_id, subject_id)
		pending_option = SurveyPendingOption.where(user_id: user_id, completed: false, subject_id: subject_id).first
		if pending_option.nil?
			0
		else
			pending_option.survey_id
		end					
	end
end