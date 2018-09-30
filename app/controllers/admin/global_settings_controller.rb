class Admin::GlobalSettingsController < AdminController

  # GET /global_settings
  # GET /global_settings.json
  def index
    # Journey Page Mode
    GlobalSetting.find_or_create_by(key: "Journey Page Mode")

    # Acurity Schedule Mode
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_URL")
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_USER")
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_PASSWORD")
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_NUM_OF_CHILD_ID")
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_NUM_OF_WORKER_ID")
    GlobalSetting.find_or_create_by(key: "ACUITY_SCHEDULE_CARD_TYPE_ID")

    #INITIAL_MEMBER_LIMIT_DAY
    GlobalSetting.find_or_create_by(key: "INITIAL_MEMBER_LIMIT_DAY")

    @global_settings = GlobalSetting.all
  end

  # GET /global_settings/new
  def new
    @global_setting = GlobalSetting.new
  end

  # GET /global_settings/1/edit
  def edit
    set_global_setting
  end

  # POST /global_settings
  # POST /global_settings.json
  def create
    @global_setting = GlobalSetting.new(global_setting_params)

    respond_to do |format|
      if @global_setting.save
        format.html { redirect_to admin_global_settings_url, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @global_setting }
      else
        format.html { render :new }
        format.json { render json: @global_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /global_settings/1
  # PATCH/PUT /global_settings/1.json
  def update
    set_global_setting
    respond_to do |format|
      if @global_setting.update(global_setting_params)
        format.html { redirect_to admin_global_settings_url, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @global_setting }
      else
        format.html { render :edit }
        format.json { render json: @global_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /global_settings/1
  # DELETE /global_settings/1.json
  def destroy
    set_global_setting
    @global_setting.destroy
    respond_to do |format|
      format.html { redirect_to admin_global_settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_global_setting
      @global_setting = GlobalSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def global_setting_params
      params.require(:global_setting).permit(:key, :value, :description)
    end
end
