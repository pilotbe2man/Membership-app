# == Schema Information
#
# Table name: user_daycares
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
    factory :user_daycare do

        association :user
        association :daycare
    end
end
