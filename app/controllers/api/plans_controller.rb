class Api::PlansController < ApiController

    def show
        set_plan
        render json: @plan, status: 200
    end

    private

    def set_plan
        @plan ||= Plan.find_by_allocation(params[:id])
    end
end