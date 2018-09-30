class Users::MedicalProfessionalsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['medical_professional'])}

  def choose_child
    format_children_name_birthdate
  end

  def submit_invite_code
    set_invitation

    if @invitation
      @invitation.accept!

      set_child
      @active_child.collaborators.find_or_create_by(collaborator: current_user)

      redirect_to medical_professional_discussions_path(child_id: @active_child.id), notice: "Congratulations! You have added #{@active_child.name} to Health Conversations!"
    else
      rendirect_to :back, alert: 'Invite code doesnt exist!'
    end
  end

  def search_child_collaboration
    child_name, birthdate = parse_child_name_birthday

    if child_name.present? && birthdate.present?
      @children = Child.search_by_name("%#{child_name}%").search_by_birth_date(birthdate)
    else
      @children = Child.search_by_name("%#{child_name}%")
    end
  end

  def initiate_child_collaboration
    invitation = CollaborationInvite.where(invitee_email: current_user.email, child_id: params[:child_id]).first

    if invitation.present?
      redirect_to submit_invite_code_path(invite_code: invitation.invite_code)
    else
      redirect_to choose_child_invitation_path, alert: "You have no permission to collaborate on this child."
    end
  end

  private

  def set_invitation
    @invitation = CollaborationInvite.find_by(invite_code: params[:invite_code])
  end

  def set_child
    @active_child = @invitation.child
  end

  def format_children_name_birthdate
    children = Child.all
    @children_name_birthdate = children.collect do |child|
      child.name + " - #{child.birth_date.strftime('%d/%m/%Y')}"
    end
  end

  def parse_child_name_birthday
    child_name_birthdate = params[:invitee_child].split(' - ')

    if child_name_birthdate.size == 2
      birthdate = child_name_birthdate.pop()
      name = child_name_birthdate.join(' ')
    else
      name = child_name_birthdate.join(' ')
      birthdate = nil
    end

    [name, birthdate]
  end

end
