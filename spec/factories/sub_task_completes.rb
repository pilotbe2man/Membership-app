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

FactoryGirl.define do

  factory :sub_task_complete do
    association :submitter, factory: :user
    association :todo_task_complete
    association :sub_task

    factory :passed_sub_task_complete do
      result 'pass'
    end

    factory :pending_sub_task_complete do
      result 'pending'
    end

  end

end
