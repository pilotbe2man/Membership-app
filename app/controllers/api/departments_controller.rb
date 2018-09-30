class Api::DepartmentsController < ApiController

    def index
        set_daycare
        render json: { departments: @daycare.departments.map{|d| department_serialisation(d) } }, status: 200
    end

    private

    def set_daycare
        @daycare ||= Daycare.find(params[:daycare_id])
    end

    def department_serialisation d
        {
            id: d.id,
            name: d.name
        }
    end
end