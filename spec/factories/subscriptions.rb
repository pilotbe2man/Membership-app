
# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  plan_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  terms            :boolean          default("false")
#  month            :integer
#  discount_code_id :integer
#  transaction_id   :integer
#  payment_mode_id  :integer
#

FactoryGirl.define do
  factory :subscription do
    terms { true }

    association :user
    association :plan
    association :discount_code
  end
end