class HealthRecordsController < ApplicationController
  layout 'dashboard_v2'

  def show
    set_health_record

    if request.xhr?
      render layout: false
    end
  end

  private

  def set_health_record
    @record ||= HealthRecord.find params[:id]
  end

end
