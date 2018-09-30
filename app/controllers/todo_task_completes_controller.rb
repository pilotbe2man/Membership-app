class TodoTaskCompletesController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def update
        set_todo_task_complete
        set_todo_complete
        set_sub_task_complete
        result = true
        @sub_task_complete.each do |subtask|
            result &&= subtask.pass?
        end
        update_task_to_pass if result == true
        redirect_to todo_todo_complete_url(@todo_complete.todo, @todo_complete), notice: 'Successfully marked task as completed.'
    end

    private

    def set_todo_task_complete
        @todo_task_complete = current_user.task_completes.find(params[:id])
    end

    def set_todo_complete
        @todo_complete = @todo_task_complete.todo_complete
    end

    def set_sub_task_complete
        @sub_task_complete = SubTaskComplete.where(todo_task_complete_id: @todo_task_complete.id)
    end

    def update_task_to_pass
        @todo_task_complete.update(completion_date: Time.now, result: 1)
    end
end
