class Users::ParenteesController < ApplicationController
  layout 'dashboard'

  def select_daycare
    set_query
    set_daycares
    render layout: 'registration'
  end

  private

  def set_query
    @query = "%#{params[:query]}%"
  end

  def set_daycares
    @daycares ||= params[:query].present? ? Daycare.search(@query, params[:page], 100, 300) : Daycare.all
  end
end
