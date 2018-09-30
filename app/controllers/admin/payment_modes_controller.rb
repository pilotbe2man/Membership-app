class Admin::PaymentModesController < AdminController

  # GET /payment_modes
  # GET /payment_modes.json
  def index
    @payment_modes = PaymentMode.all
  end

  # GET /payment_modes/new
  def new
    @payment_mode = PaymentMode.new
  end

  # GET /payment_modes/1/edit
  def edit
    set_payment_mode
  end

  # POST /payment_modes
  # POST /payment_modes.json
  def create
    @payment_mode = PaymentMode.new(payment_mode_params)

    respond_to do |format|
      if @payment_mode.save
        Stripe::Coupons.put!
        format.html { redirect_to admin_payment_modes_url, notice: 'Payment Mode was successfully created.' }
        format.json { render :show, status: :created, location: @payment_mode }
      else
        format.html { render :new }
        format.json { render json: @payment_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_modes/1
  # PATCH/PUT /payment_modes/1.json
  def update
    set_payment_mode
    respond_to do |format|
      if @payment_mode.update(payment_mode_params)
        format.html { redirect_to admin_payment_modes_url, notice: 'Payment Mode was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_mode }
      else
        format.html { render :edit }
        format.json { render json: @payment_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_modes/1
  # DELETE /payment_modes/1.json
  def destroy
    set_payment_mode
    @payment_mode.destroy
    respond_to do |format|
      format.html { redirect_to admin_payment_modes_url, notice: 'Payment Mode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_mode
      @payment_mode = PaymentMode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_mode_params
      params.require(:payment_mode).permit(:period, :unit)
    end
end
