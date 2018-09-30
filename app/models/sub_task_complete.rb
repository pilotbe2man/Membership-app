# == Schema Information
#
# Table name: sub_task_completes
#
#  id                    :integer          not null, primary key
#  submitter_id          :integer
#  todo_task_complete_id :integer
#  sub_task_id           :integer
#  completion_date       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  result                :integer          default("0")
#

class SubTaskComplete < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  belongs_to :submitter, class_name: 'User'
  belongs_to :todo_task_complete
  belongs_to :sub_task

  validates :submitter_id, :todo_task_complete_id, :sub_task_id, presence: true

  enum result: [:pending, :pass, :failed]

  after_update :assign_task_completion_date

  # If all sub tasks are marked as completed, set the parent subtask as completed too
  def assign_task_completion_date
    if todo_task_complete.sub_task_completes.map(&:result).exclude?('pending')
      todo_task_complete.update_column(:completion_date, Time.now)
    end
  end
end
