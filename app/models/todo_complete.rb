# == Schema Information
#
# Table name: todo_completes
#
#  id              :integer          not null, primary key
#  submitter_id    :integer
#  todo_id         :integer
#  completion_date :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default("0")
#

class TodoComplete < ActiveRecord::Base
    default_scope { order(created_at: :asc) }
    
    has_many :task_completes,                   class_name: 'TodoTaskComplete', dependent: :destroy
    has_many :tasks,                            through: :task_completes, source: :todo_task
    belongs_to :submitter,                      class_name: 'User'
    belongs_to :todo

    scope :incomplete,                          -> { where.not(id: nil).where(completion_date: nil) }

    scope :generate_report,                     -> (todo_id, start_date, end_date, department) { 
                                                    joins("LEFT JOIN users ON todo_completes.submitter_id = users.id")
                                                    .where("users.department_id = ?", department)
                                                    .where(todo_id: todo_id)
                                                    .where('todo_completes.created_at > ?', start_date)
                                                    .where('todo_completes.created_at < ?', end_date) }

    scope :single_generate_report,              -> (id, todo_id, start_date, end_date, department) { 
                                                    joins("LEFT JOIN users ON todo_completes.submitter_id = users.id")
                                                    .where("users.department_id = ?", department)
                                                    .where(todo_id: todo_id)
                                                    .where(id: id)
                                                    .where('todo_completes.created_at > ?', start_date)
                                                    .where('todo_completes.created_at < ?', end_date) }

    scope :last_department_complete,            -> (todo_id, department) { 
                                                    joins("LEFT JOIN users ON todo_completes.submitter_id = users.id")
                                                    .where("users.department_id = ?", department)
                                                    .where(todo_id: todo_id) }

    validates :submitter_id, :todo_id,          presence: true

    #validates :submitter_id,                    uniqueness: { scope: [:status, :todo_id] }, :if => :todo_recurring?

    scope :recurring,                           -> { includes(:todo).where(todos: { iteration_type: 1}) }

    enum status: [:active, :inactive]

    after_create :todo_task_completes
    after_create :assign_user_occurrence

    # => Checks if a todo attempt is completed by the user
    #
    def complete?
        !completion_date.nil? ? true : false
    end

    # => Checks if the todo attempt has passed all tasks
    #
    def pass?
        task_completes.map(&:result).exclude?("pending") && task_completes.map(&:result).exclude?("failed") ? true : false
    end

    # => Checks if a todo attempt is still pending (has yet to be marked as pass or failed)
    #
    def pending?
        task_completes.map(&:result).exclude?("failed") ? true : false
    end

    # => Checks if a todo is a recurring iteration type
    #
    def todo_recurring?
        todo.recurring? ? true : false
    end

    # => Creates the related todo tasks attempts when starting a todo
    #
    def todo_task_completes
        todo.tasks.each do |task|
            TodoTaskComplete.create(todo_complete_id: id, todo_task_id: task.id, submitter_id: submitter_id)
        end
    end

    # => Assign user ocurrence for user and todo if the todo interation type is recurring
    #
    def assign_user_occurrence
        UserOccurrence.create(user_id: submitter_id, todo_id: todo_id) if todo.recurring?
    end
end
