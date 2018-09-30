# == Schema Information
#
# Table name: user_occurrences
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
    factory :user_occurrence do

        # association :user
        # association :todo

        factory :active_user_occurrence do
            status { 'active' }
        end

        factory :inactive_user_occurrence do
            status { 'inactive' }
        end
    end
end
