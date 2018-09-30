class ManagerInviteEmailJob < ActiveJob::Base
    queue_as :mailers
  def perform(users, subject, content, from_email, from_name)
    users.each do |user|
    	DaycareInviteMailer.invite(user, subject, content, from_email, from_name).deliver_now
    end
  end
end