# == Schema Information
#
# Table name: affiliates
#
#  id             :integer          not null, primary key
#  name           :string
#  address        :string
#  postcode       :string
#  country        :string
#  telephone      :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  url            :string
#
# Indexes
#
#  index_affiliates_on_name  (name)
#

FactoryGirl.define do
  factory :affiliate do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    postcode { Faker::Address.zip_code }
    country   { Faker::Address.country }
    telephone { Faker::PhoneNumber.phone_number }

    association :partner, factory: :user
  end
end
