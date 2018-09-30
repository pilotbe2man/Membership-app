# == Schema Information
#
# Table name: collaboration_invites
#
#  id            :integer          not null, primary key
#  child_id      :integer
#  inviter_id    :integer
#  invitee_email :string
#  status        :integer          default("0")
#  invite_code   :string
#

class CollaborationInvite < ActiveRecord::Base
  belongs_to :child
  belongs_to :inviter, class_name: 'User'

  validates :child_id, :inviter_id, :invitee_email, presence: true
  enum status: [:pending, :accepted]

  before_create :assign_invite_code


  def generate_invite_code
    ('a'..'z').to_a.shuffle[0,10].join.upcase
  end

  def assign_invite_code
    self.invite_code = generate_invite_code
  end

  def accept!
    self.update_attributes(status: 'accepted')
  end

end
