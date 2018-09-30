# == Schema Information
#
# Table name: user_profiles
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  phone_number     :integer
#  physical_address :string
#  web_address      :string
#  about_yourself   :string
#  education        :string
#  online_presence  :boolean          default("true")
#  created_at       :datetime
#  updated_at       :datetime
#  certifications   :text             default("{}"), is an Array
#

FactoryGirl.define do
  factory :user_profile do
    phone_number { Faker::PhoneNumber.phone_number }
    physical_address { Faker::Address.street_address }

    association :user, factory: :user
  end
end
