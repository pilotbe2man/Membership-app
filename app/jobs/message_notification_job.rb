class MessageNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(message, opts={})
    message.owner.message_invite_emails.where(department: opts[:target_department], role: opts[:target_role]).each do |email|
      if email.email.present?
        NotificationMailer.notify1(message.owner, message.content, email.email).deliver_now
      end
    end
    # if opts[:invitation] == true
    #   target_users = get_target_all_users(message, opts)
    # elsif opts[:partner] == true
    #   target_users = get_target_all_users(message, opts)
    # elsif opts[:illness] == true
    #   target_users = get_target_all_users_for_illness(message, opts)
    # else
    #   target_users = get_target_users(message, opts)
    # end

    # target_users.each do |user|
    #   if user.id != message.owner.id
    #     notif = message.notifications.build(target_id: user.id)
    #     if notif.save!
    #       unless user.role == 'parentee' or user.role == 'worker' 
    #         NotificationMailer.notify(notif, message.owner, message.content).deliver_now
    #       end
    #     end
    #   end
    # end
  end

  private

  def get_target_users(message, opts)
    recipients = []
    sender = message.owner

    if sender.admin? || sender.partner?
      recipients += User.parentee if message.for_parentee?
      recipients += User.worker if message.for_worker?
      recipients += User.manager if message.for_manager?
    elsif sender.manager?
      recipients += sender.daycare.workers if message.for_worker?
      if opts[:target_department]
        dept_id = opts[:target_department].to_i
        recipients = recipients.select{|rec| rec.department_id == dept_id}
      end

      recipients += sender.daycare.parents if message.for_parentee?

    elsif sender.worker?
      recipients += sender.daycare.parents if message.for_parentee?
    end

    recipients
  end

  def get_target_all_users(message, opts)
    recipients = []
    sender = message.owner

    if opts[:partner] == true && !opts[:affiliate_id].nil?
      recipients += Affiliate.find(opts[:affiliate_id]).users
    else
      recipients += User.parentee if message.for_parentee?
      recipients += User.worker if message.for_worker?
      recipients += User.manager if message.for_manager?
    end
    recipients
  end

  def get_target_all_users_for_illness(message, opts)
    recipients = []
    sender = message.owner

    recipients += sender.daycare.workers if message.for_worker?
    recipients += sender.daycare.parents if message.for_parentee?

    if opts[:target_department]
      dept_id = opts[:target_department].to_i
      recipients = recipients.select{|rec| rec.department_id == dept_id}
    end
    recipients
  end

end
