class TodoCompletionDateJob < ActiveJob::Base
    queue_as :todo

    def perform *args
        TodoComplete.active.each do |todo_complete|
            if todo_complete.created_at < todo_complete.todo.completion_date_to_time
                todo_complete.inactive!
                todo_complete.task_completes.pending.update_all(result: 2)
            end
        end
    end
end
