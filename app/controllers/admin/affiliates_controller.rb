class Admin::AffiliatesController < AdminController

    def index
      @affiliates ||= Affiliate.all
      @affiliates = @affiliates.where(id: params[:id]) unless params[:id].nil?
      @affiliates = @affiliates.name_like(params[:name]) unless params[:name].nil?
      @affiliates = @affiliates.address_like(params[:address]) unless params[:address].nil?
    end

    def edit
        @affiliate = Affiliate.find(params[:id])
    end

    def update
      @affiliate = Affiliate.find(params[:id])
      respond_to do |format|
        if @affiliate.update(affiliate_params)
          format.html { redirect_to admin_affiliates_path(), notice: 'Affiliate was successfully updated.' }
          format.json { render :show, status: :ok, location: @affiliate }            
        else
          format.html { render :edit }
          format.json { render json: @affiliate.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @affiliate = Affiliate.find(params[:id])
      @affiliate.destroy      
      respond_to do |format|
        format.html { redirect_to admin_affiliates_url, notice: 'Affiliate was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def affiliate_params
        params.require(:affiliate).permit(
          :name,
          :address,          
          :postcode,          
          :telephone,          
          :country,          
          :url,          
          :affiliate_type
        )
      end

      def set_daycares
        @affiliates ||= Affiliate.all
    end
end