class IllnessNotifier

=begin
  subject      : Child
  illness      : HealthRecordComponent code: 'illness_code'
  message      : HealthRecordComponent code: 'contact_parent_code'
  target       : User(parent, partner)
  recorder     : User
=end
  def initialize(opts)
    @subject = opts[:subject]
    @illness = opts[:illness]
    @message = opts[:message]
    @recorder = opts[:recorder]

    @discussion = nil
  end

  def notify_parents!
    start_health_conversation
    send_email_notif
  end

  private

  def start_health_conversation
    @discussion = Discussion.find_or_create_by(subject: @subject) do |disc|
      disc.title = "#{@subject.name} : #{@illness}"
      disc.content = @message
      disc.owner = @recorder
    end

    @discussion.discussion_participants.find_or_create_by(participant: @subject.department)
    @discussion.discussion_participants.find_or_create_by(participant: @subject.parentee)
    @subject.collaborators.find_or_create_by(collaborator: @subject.department)
  end

  def send_email_notif
    HealthConversationNotificationJob.perform_now(@discussion, sender: @recorder.department)
  end

end
