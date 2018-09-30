# == Schema Information
#
# Table name: todo_task_completes
#
#  id               :integer          not null, primary key
#  submitter_id     :integer
#  todo_complete_id :integer
#  todo_task_id     :integer
#  completion_date  :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  result           :integer          default("0")
#

class TodoTaskComplete < ActiveRecord::Base
    default_scope { order(created_at: :asc) }
    belongs_to :submitter,                                                      class_name: 'User'
    belongs_to :todo_complete
    belongs_to :todo_task

    has_many :sub_task_completes
    validates :submitter_id, :todo_complete_id, :todo_task_id,                  presence: true

    scope :report, -> (todo_complete_ids, todo_task_id) { where(todo_complete_id: todo_complete_ids).where(todo_task_id: todo_task_id) }
    scope :all_report, -> (todo_complete_ids) { where(todo_complete_id: todo_complete_ids) }

    enum result: [:pending, :pass, :failed]

    after_update :assign_parent_completion_date
    after_create :create_sub_task_completes

    # => If all todo task attempts are marked as complete, set the parent todo attempt as completed too
    #
    def assign_parent_completion_date
        if todo_complete.task_completes.map(&:result).exclude?("pending")
            todo_complete.update_column(:completion_date, Time.now)
            UserOccurrence.create(user_id: submitter_id, todo_id: todo_complete.todo_id) if todo_complete.todo.recurring?
        end
    end

    # => Creates the related sub-tasks attempts when starting a todo task
    def create_sub_task_completes
      todo_task.sub_tasks.each do |sub_task|
        SubTaskComplete.create(
          todo_task_complete_id: id,
          sub_task_id: sub_task.id,
          submitter_id: submitter_id)
      end
    end
end
