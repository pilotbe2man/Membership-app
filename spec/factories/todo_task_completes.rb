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

FactoryGirl.define do
    factory :todo_task_complete do

        association :submitter, factory: :user
        association :todo_complete
        association :todo_task

        factory :passed_todo_task_complete do
            result { 'pass' }
        end

        factory :pending_todo_task_complete do
            result { 'pending' }
        end
    end
end
