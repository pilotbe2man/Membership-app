class Manager::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['manager'])}

  def index
    set_department
    set_department_children
    set_child
    set_discussions
  end

  def create
    discussion = Discussion.new(discussion_params.merge(owner_id: current_user.id))

    if discussion.save!
      save_discussion_participants(discussion)

      HealthConversationNotificationJob.perform_now(discussion, sender: current_user)
      render partial: '/discussions/discussion', locals: {discussion: discussion}
    else
      redirect_to parentee_discussions_path
    end
  end

  private

  def set_department
    if params[:department_id]
      @active_department = current_user.daycare.departments.detect{|dept| dept.id == params[:department_id].to_i}
    else
      @active_department = current_user.daycare.departments.first
    end
  end

  def set_department_children
    @children = @active_department.children
  end

  def set_child
    if params[:child_id]
      @active_child = @children.detect{|child| child.id == params[:child_id].to_i}
    else
      @active_child = @children.first
    end
  end

  def set_discussions
    dept_ids = current_user.daycare.department_ids

    @discussions = @active_child.discussions
                   .includes(:discussion_participants, :owner)
                   .select{|disc| disc.owner == current_user ||
                           disc.discussion_participants
                             .by_type('Department')
                             .any?{|disc_part| dept_ids.include?(disc_part.participant_id)}}
  end

  def save_discussion_participants(discussion)
    params[:discussion_participants].values.each do |part|
      discussion.discussion_participants.create(participant_id: part[0], participant_type: part[1])
    end
  end

end
