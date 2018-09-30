class Admin::DiscountCodesController < AdminController

  # GET /discount_codes
  # GET /discount_codes.json
  def index
    @discount_codes = DiscountCode.all
  end

  # GET /discount_codes/new
  def new
    @discount_code = DiscountCode.new
  end

  # GET /discount_codes/1/edit
  def edit
    set_discount_code
  end

  # POST /discount_codes
  # POST /discount_codes.json
  def create
    @discount_code = DiscountCode.new(discount_code_params)

    respond_to do |format|
      if @discount_code.save
        Stripe::Coupons.put!
        format.html { redirect_to admin_discount_codes_url, notice: 'Discount code was successfully created.' }
        format.json { render :show, status: :created, location: @discount_code }
      else
        format.html { render :new }
        format.json { render json: @discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discount_codes/1
  # PATCH/PUT /discount_codes/1.json
  def update
    set_discount_code
    respond_to do |format|
      if @discount_code.update(discount_code_params)
        format.html { redirect_to admin_discount_codes_url, notice: 'Discount code was successfully updated.' }
        format.json { render :show, status: :ok, location: @discount_code }
      else
        format.html { render :edit }
        format.json { render json: @discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discount_codes/1
  # DELETE /discount_codes/1.json
  def destroy
    set_discount_code
    @discount_code.destroy
    respond_to do |format|
      format.html { redirect_to admin_discount_codes_url, notice: 'Discount code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discount_code
      @discount_code = DiscountCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_code_params
      params.require(:discount_code).permit(:code, :value, :status)
    end
end
