class CollaborationMailer < ApplicationMailer
  default template_path: 'mailers/collaboration'

  def invite invitee_email, invite_code, inviter
    @invitee_email = invitee_email
    @invite_code = invite_code
    @inviter = inviter

    mail(to: @invitee_email,
         subject: 'You have been invited to collaborate on a child using Health Childcare',
         invite_code: @invite_code,
         inviter: inviter
        )
  end
end
