class IllnessTrendsGenerator

  def initialize(current_user, opts)
    @current_user = current_user
    @opts = opts
  end

  def departments_involved
    @departments ||= Department.where(id: @opts[:department_ids]).order(name: :asc)
  end

  def daycare_involved
    @daycare ||= departments_involved.first.daycare
  end

  def illnesses_involved

    @illness ||= if @opts[:illness_codes].present?
                   Illness.where(code: @opts[:illness_codes]).order(name: :asc)
                 else
                   Illness.order(name: :asc)
                 end
  end

  def illness_data_over_children_count
    grouped_hrc = health_record_components.group_by(&:value)

    data = []
    grouped_hrc.each_pair do |illness_code, components|
      illness = illnesses_involved.find{|illness| illness.code == illness_code}
      data << [illness.name, components.size]
    end

    data
  end

  def illness_data_over_time
    trend_data = []

    trend_data << header_columns

    date_labels.each do |date|
      trend_data << generate_trend_row(date)
    end

    trend_data
  end

  private

  def generate_trend_row(date)
    row = Array.new(header_columns.size, 0)
    case @opts[:graph_type]
    when 'day'
      row[0] = date.strftime('%d/%m/%Y')
    when 'week'
      row[0] = date.strftime('%W wk %Y')
    when 'month'
      row[0] = date.strftime('%b %Y')
    when 'year'
      row[0] = date.strftime('%Y')
    end

    header_columns.each_with_index do |illness, index|
      next if index == 0

      row[index] = illness_dates[illness][date] || 0
    end

    row
  end

  def health_records
    # cond_str = ['daycare_id = ?', 'owner_type = ?']
    # cond_arr = [@current_user.daycare.id, 'Child']

    # set daycares filters
    if @opts[:daycare_ids].present?
      cond_str = ['daycare_id in (?)', 'owner_type = ?']
      cond_arr = [@opts[:daycare_ids], 'Department']
    else
      cond_str = ['daycare_id = ?', 'owner_type = ?']
      cond_arr = [@current_user.daycare.id, 'Department']
    end

    # set start_date filter
    if @opts[:start_date].present?
      cond_str << 'created_at >= ?'
      cond_arr << Date.parse(@opts[:start_date]) - 1
    end

    # set end_date filter
    if @opts[:end_date].present?
      cond_str << 'created_at <= ? '
      cond_arr << Date.parse(@opts[:end_date]) + 1
    end

    # set department filters
    if @opts[:department_ids].present?
      cond_str << 'department_id in (?)'
      cond_arr << @opts[:department_ids]
    end

    @health_records ||= HealthRecord.where(cond_str.join(' AND '), *cond_arr).order(created_at: :asc)
  end

  def health_record_components
    HealthRecordComponent.where(health_record_id: health_records, code: 'illness_code', value: illnesses_involved.map(&:code))
  end

  def health_record_components_by_code(illness)
    HealthRecordComponent.where(health_record_id: health_records, code: 'illness_code', value: illness).group("DATE_TRUNC('#{@opts[:graph_type]}', created_at)").count
  end

  def illness_dates
    @illness_dates ||= (
      illnesses_involved.inject({}) do |list, illness|
        health_record_components = health_record_components_by_code(illness.code)
        list[illness.name] = health_record_components if health_record_components.present?
        list
      end
    )
  end

  def header_columns
    @header_columns ||= ['Date'] + illness_dates.keys
  end

  def get_illness_header_index(illness)
    header_columns.find_index(illness)
  end

  def date_labels
    illness_dates.values.map(&:keys).flatten.uniq.sort
  end

end
