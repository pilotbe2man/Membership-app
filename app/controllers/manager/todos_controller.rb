class Manager::TodosController < ApplicationController
    layout 'dashboard'
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def search
        set_query
        set_accessible_todos
        search_todos
    end

    def select_department
        set_departments
    end

    def new
        @todo = current_user.todos.build
        new_icon_attachment
        # @departments = Department.where(id: params[:departments])
        set_departments
        new_task
    end

    def create
        @todo = current_user.todos.build(todo_params)
        if todo_params['iteration_type'] != 'single'
            if todo_params['frequency'] == 'week'
                @todo['start_date'] = Time.now
                @todo['start_days'] = params[:start_days].to_json
            else
                @todo['start_days'] = ''
            end
        end
        respond_to do |format|
          if @todo.save
            format.html { redirect_to dashboard_manager_todos_path }
            format.json { render :show, status: :created, location: @todo }
          else
            set_departments
            format.html { redirect_to new_manager_todo_path }
            format.json { render json: @todo.errors, status: :unprocessable_entity }
          end
        end
    end

    def show
        set_todo
    end

    def edit
        set_todo
        set_departments
    end

    def update
        set_todo
        set_new_todo if @todo.global?
        if (@old_todo.present? ? @todo.save : @todo.update(todo_params))
            redirect_to manager_todo_path(@todo), notice: 'Todo was successfully updated.'
        else
            @errors = @todo.errors.full_messages
            @todo = @old_todo
            @todo.attributes = todo_params
            render :edit
        end
    end

    def active
        set_todo
        unless @todo.daycare.nil?
            @todo.is_active = 1
            @todo.save
            department_todo = @todo.department_todos.update_all(todo_active: true)
        end

        redirect_to status_list_manager_todos_path
    end

    def inactive
        set_todo
        unless @todo.daycare.nil?
            @todo.is_active = 0
            @todo.save
            department_todo = @todo.department_todos.update_all(todo_active: false)
        end
        # department_todo = @todo.department_todos.where(department_id: params[:department_id])
        # department_todo.update_all(todo_active: false)

        redirect_to status_list_manager_todos_path
    end

    def destroy
        set_todo
        set_global_todo if @todo.local?
        #hide_todo_from_dashboard
        @todo.destroy unless @todo.global?
        redirect_to dashboard_manager_todos_path, notice: 'Todo was successfully destroyed.'
    end

    def set_date_range
        set_todo
    end

    def report
        set_todo
        set_accessible_todos
        set_report_todo_completes
    end

    def sub_todos
        set_todo
        todos = User.all_self_department_todos.where(id: current_user.id).where("todos.id = #{params[:id]}")
        render partial: '/manager/todos/department_todo', locals: {local_todos: todos, todo_title: t("todos.todo_#{@todo.id}")}
    end

    private

    def set_todo
        @todo = Todo.find(params[:id])
    end

    def set_new_todo
        @old_todo = @todo
        @todo = Todo.new(todo_params)
        @old_todo.tasks.each do |task|
            new_task = @todo.tasks.build
            new_task.attributes = task.dup.attributes

          task.sub_tasks.each do |sub_task|
            new_sub_task = task.sub_tasks.build
            new_sub_task.attributes  = sub_task.dup.attributes
          end
        end

        @todo.daycare = current_user.daycare
    end

    def new_icon_attachment
        @todo.build_icon
    end

    def new_task
      @todo.tasks.build
      @todo.tasks[0].sub_tasks.build
    end

    def set_departments
      @departments ||= current_user.daycare.departments
    end

    def todo_params
        params.require(:todo).permit(
        :title,
        :iteration_type,
        :frequency,
        :completion_date_type,
        :completion_date_value,
        :daycare_id,
        :language,
        :start_date,
        department_ids: [],
        tasks_attributes: [:_destroy, :id, :title, :description, :todo_id, :task_type, :language,
                           sub_tasks_attributes: [:id, :_destroy, :title, :sub_task_type, :language]],
        icon_attributes: [:id, :attachable_type, :attachable_id, :file]
      ).merge(user_id: current_user.id)
    end

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_accessible_todos
        @ids = (current_user.completed_todos + current_user.incomplete_todos + current_user.available_todos).map(&:id)
    end

    def set_report_todo_completes
        @todo_completes = TodoComplete.generate_report(@ids, params[:start_date], params[:end_date])
    end

    def search_todos
        #@todos ||= Todo.search(@query, @ids, params[:page], 100, 300)
        @todos = User.all_global_todos(@query).where(id: current_user.id)
    end

    def set_global_todo
        @global_todo = Todo.global.find_by_title(@todo.title)
    end

    def hide_todo_from_dashboard
        #binding.pry
        UserTodoDestroy.create(todo_id: (@global_todo ||= @todo).id, user_id: current_user.id)
    end
end
