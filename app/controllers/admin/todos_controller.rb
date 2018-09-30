class Admin::TodosController < AdminController

  def index
    @todos = Todo.all
    @todos = @todos.title_like(params[:title]) unless params[:title].nil?
    @todos = @todos.by_iteration(params[:iteration_type]) unless params[:iteration_type].nil?
    @todos = @todos.by_frequency(params[:frequency]) unless params[:frequency].nil?
    @todos = @todos.daycare_like(params[:daycare_name]) unless params[:daycare_name].nil?
    @todos = @todos.by_global(params[:global]) unless params[:global].nil?
    @todos = @todos.username_like(params[:user_name]) unless params[:user_name].nil?
    @todos = @todos.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
  end

  def show
    set_todo
  end

  def new
    @todo = current_user.todos.build
    new_icon_attachment
    set_departments
    new_task
  end

  def edit
    set_departments
    set_todo
  end

  def create
    set_departments
    params[:todo][:department_ids] = Department.ids
    params[:todo][:user_id] = current_user.id
    params[:todo][:tasks_attributes].each do |task|
      task[1][:language] = params[:todo][:language]
      unless task[1][:sub_tasks_attributes].nil?
        task[1][:sub_tasks_attributes].each do |sub_task|
          sub_task[1][:language] = params[:todo][:language]
        end
      end
    end
    @todo = current_user.todos.build(todo_params)
    respond_to do |format|
      if @todo.save
        format.html { redirect_to admin_todos_url, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        new_icon_attachment
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_todo
    set_departments
    params[:todo][:department_ids] = Department.ids
    respond_to do |format|
      if @todo.update(todo_params)
        Rails.logger.info(@todo.errors.inspect)         
        format.html { redirect_to admin_todos_url, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    set_todo
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to admin_todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.global.find(params[:id])
    end

    def set_departments
      @departments ||= Department.all
    end

    def new_icon_attachment
      @todo.build_icon
    end

    def new_task
      @todo.tasks.build
      @todo.tasks[0].sub_tasks.build
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit( :title, 
                                    :iteration_type, 
                                    :frequency, 
                                    :user_id, 
                                    :language,
                                    :completion_date_type, 
                                    :completion_date_value, 
                                    :start_date,
                                    department_ids: [], 
                                    tasks_attributes: [:_destroy, :id, :title, :description, :todo_id, :task_type, :language, 
                                        sub_tasks_attributes: [:id, :title, :_destroy, :sub_task_type, :language]], 
                                    icon_attributes: [:id, :attachable_type, :attachable_id, :file])
    end
end
