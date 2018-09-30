# == Schema Information
#
# Table name: todo_tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  task_type   :integer          default("0")
#  language    :string
#

class TodoTask < ActiveRecord::Base
    default_scope { order(created_at: :asc) }
    
    has_many :tasks_complete,                                       class_name: 'TodoTaskComplete'

    # sub-tasks-related assocs
    has_many :sub_tasks,                                            dependent: :destroy
    has_many :global_sub_tasks,                                     -> {where(sub_task_type: 0)}, class_name: 'SubTask'
    has_many :local_sub_tasks,                                      -> {where(sub_task_type: 1)}, class_name: 'SubTask'

    belongs_to :todo

    validates :title, :language,                      presence: true

    enum task_type: [:global, :local]

    before_save :is_admin_global?
    before_destroy :is_admin_global?

    accepts_nested_attributes_for :sub_tasks, allow_destroy: true
    # => Checks if user is admin or global if updating, saving or destroying a todo record
    #
    def is_admin_global?
        return true
        # if todo.global? && !todo.user.admin?
        #     errors.add :base, "You do not have permission to save or destroy this Todo Task."
        #     return false
        # end
    end
end
