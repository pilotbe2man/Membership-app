class Manager::IllnessesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> {authenticate_role!(["manager"])}

  def trends
    @trend = IllnessTrendsGenerator.new(current_user, params)
  end

  private

end
