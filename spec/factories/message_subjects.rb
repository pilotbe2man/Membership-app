# == Schema Information
#
# Table name: message_subjects
#
#  id                :integer          not null, primary key
#  title             :string
#  parent_subject_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language          :string
#
# Indexes
#
#  index_message_subjects_on_parent_subject_id  (parent_subject_id)
#

FactoryGirl.define do
  factory :message_subject do
    title { Faker::Lorem.sentence }
    language { 'English' }

    factory :sub_subject do
      parent_subject_id 1
    end

  end
end
