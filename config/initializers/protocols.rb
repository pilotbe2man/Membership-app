PROTOCOLS = {
  :child_illness_record => {
    :code       => 'child_illness_record',
    :data_codes => [
      :illness_code,
      :symptom_codes,
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
    ]
  },

  :department_illness_record => {
    :code       => 'department_illness_record',
    :data_codes => [
      :sick_workers_count,
      :sick_children_count,
      :start_date,
      :end_date,
      :possible_trigger,
      :extra_details,
      :additional_actions
    ]
  }
}.with_indifferent_access
