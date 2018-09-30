class DaycareInviteEmailJob < ActiveJob::Base
    queue_as :mailers
  def perform(message, opts={})
    target_users = get_target_all_users(message, opts)
    puts "---DaycareInviteEmailJob---"
    puts target_users
    target_users.each do |user|
    	DaycareMailer.invite(user.email, message).deliver_now
    end
  end

  private

  def get_target_all_users(message, opts)
    recipients = []
    sender = message.owner

    recipients += User.parentee if message.for_parentee?
    recipients += User.worker if message.for_worker?
    recipients += User.manager if message.for_manager?

    recipients
  end
end