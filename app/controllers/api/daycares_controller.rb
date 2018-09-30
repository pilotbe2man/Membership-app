class Api::DaycaresController < ApiController
  before_action :set_daycares, except: :by_plan

  def index
    render json: { daycares: @daycares.map{|d| daycare_serialisation(d) } }, status: 200
  end

  def featured_daycare
    render json: daycare_serialisation(@daycares[featured_daycare_index(@daycares.size)]).merge(set_size: @daycares.size), status: 200
  end

  def by_plan
    set_plan
    set_daycares_by_plan
    render json: daycare_serialisation(@daycares_by_plan[featured_daycare_index(@daycares_by_plan.size)]).merge(set_size: @daycares_by_plan.size), status: 200
  end

  private

  def set_daycares
    @daycares ||= Daycare.all
  end

  def featured_daycare_index max_range
    constant = Time.now.sec
    constant = max_range > 60 ? max_range - 60 + constant : constant
    constant % max_range
  end

  def daycare_serialisation d
    {
      id: d.id,
      name: d.name
    }
  end

  def set_plan
    @plan ||= Plan.find params[:plan_id]
  end

  def set_daycares_by_plan
    @daycares_by_plan ||= @plan.subscriptions
                        .map(&:user)
                        .reject{|user| user.id == current_user.id}
                        .map(&:daycare)
  end
end
