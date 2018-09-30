class CollaborationMailerPreview < ActionMailer::Preview

  def invite
    invitee_email = Faker::Internet.email
    invite_code = 'ABCDEFGHIJ'
    inviter = Faker::Internet.email

    CollaborationMailer.invite(invitee_email, invite_code, inviter)
  end

end
