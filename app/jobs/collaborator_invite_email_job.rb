class CollaboratorInviteEmailJob < ActiveJob::Base
  queue_as :mailers

  def perform invitee_email, invite_code, inviter
    CollaborationMailer.invite(invitee_email, invite_code, inviter).deliver_now
  end

end
