class Partner::TodosController < ApplicationController
    layout 'dashboard_v2'
    before_action -> {authenticate_role!(["partner", "worker"])}
    before_action :strategic_partnership!
    before_action :authenticate_subscribed!

    def select_daycare
        set_daycares
    end

    def results
        set_todos
        set_selected_daycares
        set_todo
        get_todo_completes
    end

    def task_result
        @todo ||= params[:id].blank? ? nil : Todo.find(params[:id])
        set_daycares
        get_todo_completes
        render partial: 'task_result'
    end

    private
    def set_daycares
        if params[:target_municipal].nil?
            @daycares ||= Daycare.all
        else
            @daycares ||= Daycare.where(municipal_id: params[:target_municipal]) 
        end
    end

    def set_selected_daycares
        @daycares ||= Daycare.where(id: params[:target_daycare])
    end

    def set_todos
        @todos ||= Todo.all
    end

    def set_todo        
        @todo ||= params[:todo_id].blank? ? nil : Todo.find(params[:todo_id])
    end

    def get_todo_completes
        submitter = []
        @daycares.each do |item|
            submitter << item.users.map(&:id)            
        end
        start_date = params[:start_date].blank? ? Date.new(1970, 1, 1) : Date.parse(params[:start_date])
        end_date = params[:end_date].blank? ? Date.today : Date.parse(params[:end_date])

        @todo_completes = TodoComplete.where(submitter_id: submitter, :created_at => start_date..end_date)
    end
end
