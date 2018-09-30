class TodoReporter
    attr_reader :todo_completes, :task_id

    def initialize data
        @todo_completes              = data[:todo_completes]
        @task_id                     = data[:task_id]
    end

    def percentages
        set_task_completes
        set_total_number_of_todo_task_completes
        return {
            complete: @total_completes.zero? ? 0 : percent_of(pass, @total_completes),
            incomplete: @total_completes.zero? ? 0 : percent_of(failed, @total_completes)
        }
    end

    def pass
        @todo_task_completes.pass.size
    end

    def failed
        # @todo_task_completes.where('result = 0 OR result = 2').size
        @todo_task_completes.failed.size + @todo_task_completes.pending.size 
    end

    private

    def set_task_completes
        if task_id == 0
            @todo_task_completes ||= TodoTaskComplete.all_report(todo_completes.map(&:id))
        else
            @todo_task_completes ||= TodoTaskComplete.report(todo_completes.map(&:id), task_id)
        end
    end

    def set_total_number_of_todo_task_completes
        @total_completes ||= @todo_task_completes.size
    end

    def percent_of n, t
        n.to_f / t.to_f * 100.0
    end
end