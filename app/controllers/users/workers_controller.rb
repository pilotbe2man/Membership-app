class Users::WorkersController < ApplicationController
    layout 'dashboard'

    def select_daycare
        set_daycares
        render layout: 'registration'
    end

    def select_type
        render layout: 'registration'
    end

    def select_department
        set_daycare
        set_departments
    end

    def get_daycares
        set_query
        @daycares ||= params[:query].present? ? Daycare.search(@query, params[:page], 100, 300) : Daycare.all
        respond_to do |format|
            format.json {render :json => @daycares}
        end
    end

    def update_daycare
        set_daycare
        current_user.daycare = @daycare
        current_user.save
        respond_to do |format|
            format.json {render :json => @daycare}
        end
    end

    def update_department
        set_daycare
        set_departments        
    end

    def change_department
        set_daycare
        current_user.daycare = @daycare
        current_user.department_id = params[:department_id]
        current_user.save
        respond_to do |format|
            format.json {render :json => @daycare}
        end
    end

    private

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_daycares
        @daycares ||= Daycare.all        
    end

    def set_daycare
        @daycare ||= Daycare.find(params[:daycare_id])
    end

    def set_departments
        @departments ||= @daycare.departments
        render layout: 'registration'
    end
end