# == Schema Information
#
# Table name: sub_tasks
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  todo_task_id   :integer
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_task_type  :integer          default("0")
#  language       :string
#

class SubTask < ActiveRecord::Base
  belongs_to :todo_task
  default_scope { order(created_at: :asc) }

  has_many   :sub_task_completes

  validates  :title, :language, presence: true

  enum sub_task_type: [:global, :local]

  before_save :is_admin_global?
  before_destroy :is_admin_global?

  def is_admin_global?
    if todo_task.global? && !todo_task.todo.user.admin?
      errors.add :base, "You do not have permission to save or destroy this Sub-task."
      return false
    end
  end
end
