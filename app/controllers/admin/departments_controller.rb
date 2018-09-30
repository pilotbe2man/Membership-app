class Admin::DepartmentsController < AdminController

    def index
        set_departments
        @departments = @departments.where(id: params[:id]) unless params[:id].nil?
        @departments = @departments.name_like(params[:name]) unless params[:name].nil?
        @departments = @departments.by_daycare(params[:daycare_id]) unless params[:daycare_id].nil?
    end

    def destroy
	    @department = Department.find(params[:id])
	    @department.destroy

	    redirect_to admin_departments_path, notice: "Department deleted."
    end

    private

    def set_departments
        @departments ||= Department.all
    end
end