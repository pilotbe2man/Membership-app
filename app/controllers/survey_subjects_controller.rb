class SurveySubjectsController < ApplicationController
    layout 'dashboard_v2'
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def results
        set_subject
        set_selected_result            
        if @subject.nil?
          redirect_to dashboard_path
        end

        if request.xhr?
          render partial: 'progress_charts'
        end
    end

    def result
        @subject ||= SurveySubject.find(params[:id])
        if @subject.nil?
          redirect_to dashboard_path
        end

        @trend = SurveyTrendsGenerator.new(@subject, [current_user.id])
        if request.xhr?
          render partial: 'progress_charts', locals: {trend: @trend}
        end
    end

    private

    def set_subject
        @subject ||= params[:subject_id].nil? ? SurveySubject.where(language: I18n.locale.upcase).first : SurveySubject.find(params[:subject_id])
    end

    def set_selected_result
        @trend = nil
        unless params[:subject_id].nil?
            subject ||= SurveySubject.find(params[:subject_id])
            @trend = SurveyTrendsGenerator.new(subject, [current_user.id])
        end
    end
end
