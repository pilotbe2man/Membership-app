# == Schema Information
#
# Table name: child_collaborators
#
#  id                :integer          not null, primary key
#  child_id          :integer
#  collaborator_id   :integer
#  collaborator_type :string
#  deactivated_at    :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_child_collaborators_on_child_id  (child_id)
#

FactoryGirl.define do
  factory :child_collaborator do
    collaborator_type { 'User' }

    association :child, factory: :child
  end
end