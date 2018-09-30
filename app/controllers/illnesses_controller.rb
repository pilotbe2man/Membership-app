class IllnessesController < ApplicationController
  layout 'dashboard_v2'

  def department_children
    set_children

    render partial: 'illnesses/child/child_selector'
  end

  def child_profile
    set_child

    render partial: 'illnesses/child/profile'
  end

  def symptoms
    set_illness
    set_symptoms

    render partial: 'illnesses/child/symptoms'
  end

  def guides
    set_illness
    set_guide

    respond_to do |format|
      format.json { render :json => { content: '' } }
    end     
  end

  def department_workers
    set_department
    set_workers

    render partial: 'worker_names'
  end

  def worker_profile
    set_worker

    render partial: 'worker_profile'
  end

  def create_child_record
    status = IllnessRecorder.new(child_illness_record_params).save_child_illness!

    if status[:code] == 'ok'
      redirect_to illnesses_path, notice: status[:message]
    else
      redirect_to new_child_record_illnesses_path, alert: status[:message]
    end
  end

  def create_department_record
    if params[:worker][:id].blank?
      status = {}
      status[:code] = "failed"
      status[:message] = "Please select worker"
    else
      status = IllnessRecorder.new(department_illness_record_params).save_department_illness!
    end

    if status[:code] == 'ok'
      # illness = Illness.where(code: params[:record][:illness_code]).first
      # message = Message.new
      # message.message_template_id = 0
      # message.title = t('mailers.illness.title')
      # message.content = t('mailers.illness.content', illness: illness.name)
      # message.target_roles = ["parentee"]
      # message.owner_id = current_user.id
      # message.save

      # if message.save
      #   MessageNotificationJob.perform(message)
      # end

      redirect_to illnesses_path, notice: status[:message]
    else
      redirect_to new_department_record_illnesses_path, alert: status[:message]
    end
  end

  def list
    params[:page] ||= 1
    set_records

    if request.xhr?
      render partial: 'health_records_list'
    else
      render 'list'
    end
  end

  def filter_children
    set_children

    render partial: 'filter_children'
  end

  private

  def set_children
    department_id = params[:department_id].to_i
    @children ||= current_user.daycare.departments.select{|dpt| dpt.id == department_id}.map(&:children).flatten.sort
  end

  def set_child
    @child ||= Child.find(params[:child_id])
  end

  def set_illness
    @illness ||= Illness.where(code: params[:illness_code]).first
  end

  def set_symptoms
    @symptoms ||= @illness.symptoms.inject({}){|list, symptom| list[symptom.code] = symptom.name; list}
  end

  def set_guide    
  end

  def set_department
    @department ||= Department.find params[:department_id]
  end

  def set_workers
    @workers ||= @department.workers
  end

  def set_worker
    @worker ||= User.find params[:worker_id]
  end

  def set_records
    cond_str, cond_arr = set_query_conditions

    @records ||= HealthRecord.where(cond_str, *cond_arr)
               .order(created_at: :desc)
               .page(params[:page])
  end

  def set_query_conditions
    cond_str = ['daycare_id = ?']
    cond_arr = [current_user.daycare.id]

    # set record type, either department or child
    if params['record_type'] == 'child'
      cond_str << 'owner_type = ?'
      cond_arr << 'Child'

      # set child filter
      if params['child_id'].present?
        cond_str << 'owner_id = ?'
        cond_arr << params['child_id']
      end
    elsif params['record_type'] == 'department'
      cond_str << 'owner_type = ?'
      cond_arr << 'Department'

      # set department filter
      if params['department_id'].present?
        cond_str << 'owner_id = ?'
        cond_arr << params['department_id']
      end
    end

    # set start_date filter
    if params['start_date'].present?
      cond_str << 'created_at >= ?'
      cond_arr << Date.parse(params['start_date']) - 1
    end

    # set end_date filter
    if params['end_date'].present?
      cond_str << 'created_at <= ?'
      cond_arr << Date.parse(params['end_date']) + 1
    end

    [cond_str.join(' AND '), cond_arr]
  end

  def child_illness_record_params
    params.permit(
      child: [ :id ],
      department: [:id],
      record: [
        :illness_code,
        :symptoms_description,
        :start_date,
        :end_date,
        :possible_trigger,
        :extra_details,
        :contact_parent_message,
        :contact_parent_reason,
        :contact_doctor_message,
        :contact_doctor_reason,
        :additional_actions
      ],
      worker: [
        :id,
        :password
      ]
    ).merge(daycare_id: current_user.daycare.id)
  end

  def department_illness_record_params
    params.permit(
      department: [ :id ],
      record: [
        :illness_code,
        :sick_workers_count,
        :sick_children_count,
        :start_date,
        :possible_trigger,
        :extra_details,
        :additional_actions      
      ],
      worker: [
        :id,
        :password
      ]
    ).merge(daycare_id: current_user.daycare.id)
  end

end
