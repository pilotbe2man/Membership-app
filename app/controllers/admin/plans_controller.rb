class Admin::PlansController < AdminController

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
    @plans = @plans.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
    @plans = @plans.by_currency(params[:plan][:currency]) unless params[:plan].nil? || params[:plan].blank?
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
    set_plan
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to admin_plans_url, notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    set_plan
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to admin_plans_url, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    set_plan
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to admin_plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:name, :price, :allocation, :plan_type, :language, :currency, :document)
    end
end
