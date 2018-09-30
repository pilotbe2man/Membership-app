class Admin::DashboardController < AdminController

  def index
    @locale_file_data = LocaleFile.new
  end

  def create_on_s3
    @locale_file_data = LocaleFile.new(locale_files_params)
    if @locale_file_data.save
      #if data uploaded to the S3
      redirect_to admin_root_path, notice: "Successfully Uploaded"
    else
      redirect_to admin_root_path, notice: "Uploading Unsuccessful"
    end
  end

 private
  def locale_files_params
    params.require(:locale_file).permit(
      :file,
      :logo,
      :online_training,
      :email_list_template,
      :preview_link,
      :language_short_name
    )
  end
end