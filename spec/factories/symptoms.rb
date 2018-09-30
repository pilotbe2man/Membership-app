# == Schema Information
#
# Table name: symptoms
#
#  id         :integer          not null, primary key
#  illness_id :integer
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :symptom do
    code { Faker::Lorem.characters(10) }
    name { Faker::Lorem.word }

    illness
  end
end
