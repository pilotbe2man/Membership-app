module DiscussionsHelper

  def daycare_logo(daycare)
    if daycare.profile_image.present?
      daycare.profile_image.file.url
    else
      'childcare-logo-04.png'
    end
  end

  def discussion_owner_avatar(discussion)
    if discussion.owner.parentee?
      'parent.png'
    elsif discussion.owner.worker? || discussion.owner.manager?
      daycare_logo(discussion.owner.daycare)
    elsif discussion.owner.medical_professional?
      discussion.owner.user_profile.profile_image.file.url
    end
  end

  def discussion_owner_name(discussion)
    if discussion.owner.parentee?
      discussion.owner.name
    elsif discussion.owner.worker? || discussion.owner.manager?
      discussion.owner.daycare.name
    elsif discussion.owner.medical_professional?
      discussion.owner.name
    end
  end

  def discussion_owner(discussion)
    discussion.owner.worker? ? discussion.owner.department : discussion.owner
  end

  def allowed_collaborations_reached?(child)
    (child.collaborators.by_type('User').size + child.pending_collaborations.size) >= 2
  end

end
