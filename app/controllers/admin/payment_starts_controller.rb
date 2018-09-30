class Admin::PaymentStartsController < AdminController

  # GET /payment_starts
  # GET /payment_starts.json
  def index
    @payment_starts = PaymentStart.all
  end

  # GET /payment_starts/new
  def new
    @payment_start = PaymentStart.new
  end

  # GET /payment_starts/1/edit
  def edit
    set_payment_start
  end

  # POST /payment_starts
  # POST /payment_starts.json
  def create
    @payment_start = PaymentStart.new(payment_start_params)

    respond_to do |format|
      if @payment_start.save
        Stripe::Coupons.put!
        format.html { redirect_to admin_payment_starts_url, notice: 'Payment Mode was successfully created.' }
        format.json { render :show, status: :created, location: @payment_start }
      else
        format.html { render :new }
        format.json { render json: @payment_start.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_starts/1
  # PATCH/PUT /payment_starts/1.json
  def update
    set_payment_start
    respond_to do |format|
      if @payment_start.update(payment_start_params)
        format.html { redirect_to admin_payment_starts_url, notice: 'Payment Mode was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_start }
      else
        format.html { render :edit }
        format.json { render json: @payment_start.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_starts/1
  # DELETE /payment_starts/1.json
  def destroy
    set_payment_start
    @payment_start.destroy
    respond_to do |format|
      format.html { redirect_to admin_payment_starts_url, notice: 'Payment Mode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_start
      @payment_start = PaymentStart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_start_params
      params.require(:payment_start).permit(:period, :unit)
    end
end
