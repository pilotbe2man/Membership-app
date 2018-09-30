class Admin::LocalePostersController < AdminController

	def index
		set_locale_posters
	end

  def show
    set_locale_poster
  end

	def new
		new_locale_poster
		@ori_locale_poster = LocalePoster.find(params[:poster_id]) unless params[:poster_id].nil?
	end

	def edit
		set_locale_poster
	end

	def create
		LocalePoster.where(poster_type: params[:locale_poster][:poster_type], language: params[:locale_poster][:language]).destroy_all
		@locale_poster = LocalePoster.new(locale_poster_params)
		if @locale_poster.save
			redirect_to admin_locale_posters_path, notice: 'You have created a new poster'
		else
			render action: :new
		end
	end

	def update
		set_locale_poster
		if @locale_poster.update_attributes(locale_poster_params)
			redirect_to admin_locale_posters_path, notice: 'You have updated a poster'
		else
			render action: :edit
		end
	end

	def destroy
    	set_locale_poster
    	@locale_poster.destroy
    	redirect_to admin_locale_posters_path(@locale_poster), notice: 'You have successfully deleted a poster.'
  	end

	private

	def set_locale_poster
		@locale_poster ||= LocalePoster.find(params[:id])
	end

	def set_locale_posters
		@locale_posters = LocalePoster.all
		@locale_posters = @locale_posters.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
		@locale_posters = @locale_posters.by_poster_type(params[:poster_type]) unless params[:poster_type].nil? || params[:poster_type].blank?

	end
  
	def new_locale_poster
		@locale_poster = LocalePoster.new
	end

	def locale_poster_params
		params.require(:locale_poster).permit(:poster_type, :poster, :language, :description, :title, :button)
	end
end
