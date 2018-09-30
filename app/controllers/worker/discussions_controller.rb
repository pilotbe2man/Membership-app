class Worker::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(["worker"]) }

  def index
    set_department_children
    set_department_child
    set_discussions

    archive_notification
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

  def set_department_children
    @children = current_user.department.children
  end

  def set_department_child
    if params[:child_id]
      @active_child = @children.detect{|child| child.id == params[:child_id].to_i}
    else
      @active_child = @children.first
    end
  end

  def set_discussions
    @discussions = @active_child.discussions
                   .includes(:discussion_participants, :owner)
                   .select{|disc| disc.owner == current_user ||
                           disc.discussion_participants.object_is_participant?(current_user.department)}
  end

  def discussion_params
    params.require(:discussion).permit(
      :title,
      :content,
      :subject_id,
      :subject_type
    )
  end

  def save_discussion_participants(discussion)
    params[:discussion_participants].values.each do |part|
      discussion.discussion_participants.create(participant_id: part[0], participant_type: part[1])
    end
  end

end
