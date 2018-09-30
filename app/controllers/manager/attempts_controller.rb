class Manager::AttemptsController < ApplicationController
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def index
        set_survey
    end

    def show
        set_survey
        set_attempt
    end

    private

    def set_attempt
        @attempt ||= @survey.attempts.find(params[:id])
    end

    def set_survey
        @survey ||= Survey::Survey.find(params[:survey_id])
    end
end
