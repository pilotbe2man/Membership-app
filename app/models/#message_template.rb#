# == Schema Information
#
# Table name: message_templates
#
#  id             :integer          not null, primary key
#  sub_subject_id :integer
#  target_role    :integer
#  content        :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_message_templates_on_sub_subject_id  (sub_subject_id)
#

class MessageTemplate < ActiveRecord::Base
  include Deactivatable

  belongs_to :sub_subject, class_name: 'MessageSubject', foreign_key: 'sub_subject_id'
  has_many :messages

  validates :sub_subject_id, presence: true

  enum target_role: [:parentee, :worker]
end
