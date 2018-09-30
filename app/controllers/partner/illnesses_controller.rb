class Partner::IllnessesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> {authenticate_role!(["partner", "worker"])}
  before_action :strategic_partnership!

  def set_filters
    set_daycares
  end

  def trends    
    unless params[:daycare_ids].blank?      
      @trend = IllnessTrendsGenerator.new(current_user, params)
    end
  end

  def municipal_trends
    unless params[:target_municipal].blank?
      @daycares ||= Daycare.where(municipal_id: params[:target_municipal]) 
      params[:daycare_ids] = []
      @daycares.each do |item|
        params[:daycare_ids] << item.id
      end
      unless @daycares.length == 0
        @trend = IllnessTrendsGenerator.new(current_user, params)        
      end
    end
    render partial: 'municipal_trends'
  end

  private

    def set_daycares
        @daycares ||= Daycare.all
    end

end
