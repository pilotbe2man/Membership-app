class Admin::LocaleLogosController < AdminController

	def index
		set_locale_logos
	end

	def new
		new_locale_logo
	end

	def edit
		set_locale_logo
	end

	def create
		LocaleLogo.where(logo_type: params[:locale_logo][:logo_type], language: params[:locale_logo][:language]).destroy_all
		@locale_logo = LocaleLogo.new(locale_logo_params)
		if @locale_logo.save
			redirect_to admin_locale_logos_path, notice: 'You have created a new logo'
		else
			render action: :new
		end
	end

	def update
		set_locale_logo
		if @locale_logo.update_attributes(locale_logo_params)
			redirect_to admin_locale_logos_path, notice: 'You have updated a logo'
		else
			render action: :edit
		end
	end

	def destroy
    	set_locale_logo
    	@locale_logo.destroy
    	redirect_to admin_locale_logos_path(@locale_logo), notice: 'You have successfully deleted a logo.'
  	end

	private

	def set_locale_logo
		@locale_logo ||= LocaleLogo.find(params[:id])
	end

	def set_locale_logos
		@locale_logos = LocaleLogo.all
		@locale_logos = @locale_logos.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
	end
  
	def new_locale_logo
		@locale_logo = LocaleLogo.new
	end

	def locale_logo_params
		params.require(:locale_logo).permit(:logo_type, :logo, :language, 
											:description, :address1, :address2, 
											:email, :phone_number, :title, :copyright, 
											:upgrade_notifier, :invitation_notifier,
											:app_title)
	end
end
