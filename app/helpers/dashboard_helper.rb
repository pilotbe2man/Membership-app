module DashboardHelper

  def notif_per_source_type(notifs, source_type)
    notifs.select{|n| n.source_type == source_type}
  end

  def notif_sender_avatar(notif)
    sender = notif.source_owner

    if sender.admin?
      'super-admin.png'
    elsif sender.partner?
      sender.affiliate.profile_image.file.url
    elsif sender.manager?
      'manager.png'
    elsif sender.parentee?
      'parent.png'
    elsif sender.worker?
      if notif.source.kind_of?(Message) # for Message, show the worker's default avatar
        'worker.png'
      else # for Discussion, Comment, show the daycare logo
        sender.daycare.profile_image.present? ? sender.daycare.profile_image.file.url : 'childcare-logo-04.png'
      end
    else
      'logo_menu.png'
    end
  end

  def notif_sender_name(notif)
    if ['Discussion', 'Comment'].include?(notif.source_type) && notif.source_owner.worker?
      notif.source_owner.daycare.name
    else
      notif.source_owner.name
    end
  end

  def discussion_notif_link(notif)
    if current_user.parentee?
      parentee_discussions_path(child_id: notif.source.subject_id, notification_id: notif.id)
    elsif current_user.worker?
      worker_discussions_path(child_id: notif.source.subject_id, notification_id: notif.id)
    else
      '#'
    end
  end

end
