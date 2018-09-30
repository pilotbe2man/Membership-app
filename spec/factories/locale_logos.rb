# == Schema Information
#
# Table name: locale_logos
#
#  id                  :integer          not null, primary key
#  logo_type           :integer
#  logo_file_name      :string
#  logo_content_type   :string
#  logo_file_size      :integer
#  logo_updated_at     :datetime
#  language            :string
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  address1            :string
#  address2            :string
#  email               :string
#  phone_number        :string
#  title               :string
#  copyright           :string
#  upgrade_notifier    :string
#  invitation_notifier :string
#

FactoryGirl.define do
  factory :locale_logo do
    type 1
    logo ""
    language "MyString"
  end
end
