class Manager::Reports::TodosController < ApplicationController
    layout 'dashboard'

    def index
        
    end

    def show
        if params[:department].nil? || params[:start_date].blank? || params[:end_date].blank? || params[:complete_id].blank?
            redirect_to manager_reports_todos_root_path
        end
        set_global_todo
        set_department
        set_single_report_todo_completes
    end

    def search
        set_query
        set_accessible_todos
        search_todos
    end

    def set_date_range
        if params[:department].nil?
            redirect_to manager_reports_todos_root_path
        end
        set_global_todo
    end

    def select_todo_result
        if params[:department].nil? || params[:start_date].blank? || params[:end_date].blank?
            redirect_to manager_reports_todos_root_path
        end
        set_global_todo
        set_department
        set_report_todo_completes        
    end

    private

    def set_department
        @department = Department.find(params[:department])
    end    

    def set_global_todo
        @todo = Todo.find(params[:todo_id])
    end

    def set_accessible_todos
        @ids = (current_user.completed_todos + current_user.incomplete_todos + current_user.available_todos).map(&:id)
    end

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_report_todo_completes
        @todo_completes = TodoComplete.generate_report(@todo.id, params[:start_date], params[:end_date], params[:department])
    end

    def set_single_report_todo_completes
        @todo_complete = TodoComplete.single_generate_report(params[:complete_id], @todo.id, params[:start_date], params[:end_date], params[:department])
    end

    def search_todos
        #@todos ||= Todo.search(@query, @ids, params[:page], 100, 300)
        @todos = User.all_global_todos(@query).where(id: current_user.id)
    end
end