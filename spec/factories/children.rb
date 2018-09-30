# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  parent_id     :integer
#  department_id :integer
#  birth_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :child do
    name       { Faker::Name.name }
    birth_date { Faker::Date.between(1.year.ago, 5.years.ago) }

    before(:create) do |child, evaluator|
      child.profile_image = FactoryGirl.create :child_profile_image, attachable: child
    end

    transient do
      pending_collaborations 10
    end

    association :department
    association :parentee, factory: :user
  end
end
