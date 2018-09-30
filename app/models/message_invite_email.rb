class MessageInviteEmail < ActiveRecord::Base

  belongs_to :user

  #default_scope {order('created_at DESC')}
  scope :parentee, -> {where(role: 'parentee')}
  scope :worker, -> {where(role: 'worker')}
end