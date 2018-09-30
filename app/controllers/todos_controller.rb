class TodosController < ApplicationController
    layout 'dashboard'
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def index
    end

    def search
        set_query
        set_accessible_todos
        search_todos
    end

    private

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_accessible_todos
      @ids = (current_user.global_todos + current_user.local_todos).map(&:id)
    end

    def search_todos
        @todos ||= Todo.search(@query, @ids, params[:page], 100, 300)
    end
end