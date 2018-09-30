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

FactoryGirl.define do
    factory :todo_complete do

        association :todo
        association :submitter, factory: :user

        # completion_date { 2.days.ago.to_date }
    end
end
