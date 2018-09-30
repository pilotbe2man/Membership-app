# == Schema Information
#
# Table name: subjects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deactivated_at :datetime
#

FactoryGirl.define do
  factory :subject do
    title "MyString"
  end
end
