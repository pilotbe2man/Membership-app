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

# possible collaborators : [User: [parent, partner, doctor-partner], Department]
class ChildCollaborator < ActiveRecord::Base
  belongs_to :child
  belongs_to :collaborator, polymorphic: true

  scope :by_type, ->(type) {where(collaborator_type: type)}
end
