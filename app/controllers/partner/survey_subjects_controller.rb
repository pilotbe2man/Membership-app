class Partner::SurveySubjectsController < ApplicationController
    layout 'dashboard_v2'
    before_action -> {authenticate_role!(["partner", "worker"])}
    before_action :strategic_partnership!

    def results

        # Strategic Partner
        set_subject
        set_selected_daycares

#        @trend = SurveyTrendsGenerator.new(@subject, population)

        if request.xhr?
          render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
        end
    end

    def get_results
        set_subject            
    end

    def result

        if current_user.affiliate.strategic?
            unless params[:target_daycare].nil?
                set_selected_daycares
            else
                set_daycares_from_municipal
            end
            set_daycare_users
        else
            set_affiliate_users
        end

        @subject ||= SurveySubject.find(params[:id])
        @trend = SurveyTrendsGenerator.new(@subject, @population, params[:start_date], params[:end_date])
        
        if request.xhr?
          render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
        end
    end

    def daycare_result
        set_subject
        params[:target_daycare] = [params[:daycare_id]]

        set_selected_daycares
        set_daycare_users

        @trend = SurveyTrendsGenerator.new(@subject, @population, params[:start_date], params[:end_date])
        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
    end

    def user_result
        set_subject
        population = [params[:user_id]]
        @trend = SurveyTrendsGenerator.new(@subject, population)
        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}        
    end

    def group_result
        set_subject
        set_affiliate_users

        @trend = SurveyTrendsGenerator.new(@subject, @population)
        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}        
    end

    def daycare_group_result
        set_subject
        set_selected_daycares
        set_daycare_users

        @trend = SurveyTrendsGenerator.new(@subject, @population, params[:start_date], params[:end_date])
        render partial: 'survey_subjects/progress_charts', locals: {trend: @trend}
    end

    def select_daycare
        set_daycares
    end

    private

    def set_selected_daycares
        @daycares ||= Daycare.where(id: params[:target_daycare])
    end

    def set_daycares_from_municipal
       @daycares ||= Daycare.where(municipal_id: params[:target_municipal]) 
    end

    def set_daycares
        if params[:target_municipal].nil?
            @daycares ||= Daycare.all
        else
            @daycares ||= Daycare.where(municipal_id: params[:target_municipal]) 
        end
    end

    def set_subject
        @subject ||= SurveySubject.where(language: I18n.locale.upcase).first
    end

    def set_daycare_users
        @population =[]
        @daycares.each do |daycare|
            @population << daycare.workers.map(&:id) unless daycare.workers.blank?
            @population << daycare.parents.map(&:id) unless daycare.parents.blank?
        end
    end

    def set_workers
        @workers = current_daycare.workers
    end

    def set_parents
        @parents = current_daycare.parents
    end

    def set_affiliate_users
        @population =[]
        @population = current_user.affiliate.users.map(&:id)
    end
end
