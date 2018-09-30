# == Schema Information
#
# Table name: discount_code_daycares
#
#  id               :integer          not null, primary key
#  discount_code_id :integer
#  daycare_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :discount_code_daycare do
    discount_code_id 1
    daycare_id 1
  end
end
