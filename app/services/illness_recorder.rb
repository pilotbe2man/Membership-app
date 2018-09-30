# coding: utf-8
class IllnessRecorder

  def initialize(opts)
    @opts = opts.with_indifferent_access

    verify_recorder(@opts[:worker])
  end

  def save_child_illness!
    @owner = Child.find @opts[:child][:id]
    @protocol_code = PROTOCOLS['child_illness_record']['code']

    perform!
  end

  def save_department_illness!
    @owner = Department.find @opts[:department][:id]
    @protocol_code = PROTOCOLS['department_illness_record']['code']

    perform!
  end

  private

  def perform!
    return {code: 'error', message: I18n.t('health_records.flashes.invalid_worker_pw')} unless @recorder

    init_record
    init_record_components

    if @record.save!
      trigger_component_extra_actions
      return {code: 'ok', message: I18n.t('health_records.flashes.create_success')}
    else
      return{code: 'error', message: I18n.t('health_records.flashes.create_error')}
    end
  end

  private

  def verify_recorder(worker)
    user = User.find(worker[:id])

    @recorder = user.valid_password?(worker[:password]) ? user : nil
  end

  def init_record
    @record ||= HealthRecord.create(
      protocol_code: @protocol_code,
      owner: @owner,
      recorder: @recorder,
      daycare_id: @opts[:daycare_id],
      department_id: @opts[:department][:id]
    )
  end

  def init_record_components
    @opts[:record].each_pair do |code, value|
      @record.health_record_components.build(code: code, value: value) if value.present?
    end
  end

  def trigger_component_extra_actions
    contact_parent = @record.health_record_components.where(code: 'contact_parent_message').try(:first)
    
    if contact_parent.present?
      illness = @record.health_record_components.where(code: 'illness_code').first

      IllnessNotifier.new(
        subject: @owner,
        illness: illness.pretty_value,
        message: contact_parent.value,
        recorder: @recorder
      ).notify_parents!
    end
  end

end
