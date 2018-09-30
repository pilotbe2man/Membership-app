# == Schema Information
#
# Table name: discussions
#
#  id             :integer          not null, primary key
#  title          :string
#  subject_id     :integer
#  subject_type   :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#  content        :string
#
# Indexes
#
#  index_discussions_on_subject_type_and_subject_id  (subject_type,subject_id)
#

FactoryGirl.define do
  factory :discussion do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(10) }

    association :subject, factory: :child
    association :owner, factory: :user
  end
end