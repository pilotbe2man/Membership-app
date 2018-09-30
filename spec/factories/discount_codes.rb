# == Schema Information
#
# Table name: discount_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  value      :integer          default("0")
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :discount_code do
    code { 'MyString' }
    value { 9.99 }
    status { 'active' }
  end
end