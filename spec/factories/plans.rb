# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  
#  plan_type: 1: Daily amount
#             2: Phase 1 Deposit
#             3: Phase 2 Deposit
#             4: Phase 3 Deposit
#

FactoryGirl.define do
  factory :plan do
    name { 'Per Children Per Day' }
    plan_type { 1 }
    language { 'English' }
    price { 5.0 }
    allocation { 30 }
    currency { 'usd' }
  end
end