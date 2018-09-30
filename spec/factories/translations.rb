# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string
#  key            :string
#  value          :text
#  interpolations :text
#  is_proc        :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :translation do
    locale "MyString"
    key "MyString"
    value {['MyText','Text']}
    interpolations {['MyText','Text']}
    is_proc false
  end
end
