class Admin::EmailCampaignsController < AdminController

	def index
		set_email_campaigns
	end

	def new
		new_email_campaign
	end

	def edit
		set_email_campaign
	end

	def create
		@email_campaign = EmailCampaign.new(email_campaign_params)
		if @email_campaign.save
			redirect_to admin_email_campaigns_path, notice: 'You have created a new email campaign template'
		else
			render action: :new
		end
	end

	def update
		set_email_campaign
		if @email_campaign.update_attributes(email_campaign_params)
			redirect_to admin_email_campaigns_path, notice: 'You have updated a email campaign template'
		else
			render action: :edit
		end
	end

	def destroy
    	set_email_campaign
    	@email_campaign.destroy
    	redirect_to admin_email_campaigns_path(@email_campaign), notice: 'You have successfully deleted a Email Campaign template.'
  	end

	private

	def set_email_campaign
		@email_campaign ||= EmailCampaign.find(params[:id])
	end

	def set_email_campaigns
		@email_campaigns = EmailCampaign.all
		@email_campaigns = @email_campaigns.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
	end
  
	def new_email_campaign
		@email_campaign = EmailCampaign.new
	end

	def email_campaign_params
		params.require(:email_campaign).permit(:subject, :content, :language)
	end
end