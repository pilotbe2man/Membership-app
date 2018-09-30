# == Schema Information
#
# Table name: survey_subjects
#
#  id             :integer          not null, primary key
#  title          :string
#  daycare_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :text
#  deactivated_at :datetime
#  language       :string
#  remote_id      :integer
#

FactoryGirl.define do
  factory :survey_subject do
    name "MyString"
    daycare_id 1
  end
end
