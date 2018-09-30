# == Schema Information
#
# Table name: payment_modes
#
#  id         :integer          not null, primary key
#  period     :integer
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :payment_mode do
    period 1
    unit "MyString"
  end
end
