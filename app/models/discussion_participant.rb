# == Schema Information
#
# Table name: discussion_participants
#
#  id               :integer          not null, primary key
#  discussion_id    :integer
#  participant_id   :integer
#  participant_type :string
#  initiator        :boolean
#  deactivated_at   :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_discussion_participants_on_discussion_id  (discussion_id)
#

class DiscussionParticipant < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :participant, polymorphic: true

  scope :by_type, ->(type) {where(participant_type: type)}
end
