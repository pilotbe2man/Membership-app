class HealthConversationNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(notif_source, opts={})
    sender = opts[:sender]
    notification_targets =  get_target_users(notif_source, sender)

    notification_targets.each do |target|
      notif = notif_source.notifications.build(target_id: target.id)
      if notif.save!
        NotificationMailer.notify(notif, sender).deliver_now
      end
    end

  end

  private

  def get_target_users(notif_source, sender)
    recipients = []

    notif_source.discussion_participants.each do |disc_participant|
      participant_obj = disc_participant.participant

      next if (participant_obj == sender)

      if participant_obj.kind_of?(Department)
        recipients += participant_obj.workers
      else
        recipients << participant_obj
      end
    end

    recipients
  end

end
