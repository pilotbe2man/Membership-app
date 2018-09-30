class Admin::IllnessGuideUpdatesController < AdminController
	before_filter :set_illness, only: [:edit, :update, :destroy]

	def index
	  @illness_guide_update = IllnessGuideUpdate.all
	  @illness_guide_update = @illness_guide_update.where("title LIKE ?", "%#{params[:name]}%")  unless params[:name].nil?
	end	  

	def new
	  @illness_guide_update = IllnessGuideUpdate.new
	end

	def create
	  @illness_guide_update = IllnessGuideUpdate.new(illness_guide_update_params)
	  respond_to do |format|
	    if @illness_guide_update.save
	      format.html { redirect_to admin_root_path, notice: 'Illness guide was successfully created.' }
	      format.json { render :show, status: :ok, location: @illness_guide_update }
	    else
	      format.html { render :edit }
	      format.json { render json: @illness_guide_update.errors, status: :unprocessable_entity }
	    end
	  end
	end

	def update
	  respond_to do |format|
	    if @illness_guide_update.update(illness_guide_update_params)
	      format.html { redirect_to admin_illness_guide_updates_path, notice: 'Illness guide was successfully updated.' }
	      format.json { render :show, status: :ok, location: @illness_guide_update }
	    else
	      format.html { render :edit }
	      format.json { render json: @illness_guide_update.errors, status: :unprocessable_entity }
	    end
	  end
	end

	def destroy
	  @illness_guide_update.destroy

	  respond_to do |format|
	    format.html { redirect_to admin_illness_guide_updates_path, notice: 'Illness guide was successfully destroyed.' }
	    format.json { head :no_content }
	  end
	end

	def upload
	  if request.post?
	    build_illness_from_spreadsheet
	    redirect_to admin_illnesses_path(), notice: 'You have successfully uploaded a illness module'
	  end
	end

	private

	def set_illness
	  @illness_guide_update = IllnessGuideUpdate.find(params[:id])
	end

	def illness_guide_update_params
	  params.require(:illness_guide_update).permit(
	    :title,
	    :description,
	  )
	end
end
