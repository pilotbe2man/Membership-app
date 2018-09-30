class Admin::ManagerVideosController < AdminController

  def index
    set_videos
  end

  def new
    new_video
    @ori_video = ManagerVideo.find(params[:video_id]) unless params[:video_id].nil?
  end

  def edit
    set_video
  end

  def create
    ManagerVideo.where(video_type: params[:video][:video_type], language: params[:video][:language], category: params[:video][:category]).destroy_all rescue nil
    @video = ManagerVideo.new(video_params)
    if @video.save
      redirect_to admin_manager_videos_path, notice: 'You have created a new video'
    else
      render action: :new
    end
  end

  def update
    set_video
    if @video.update_attributes(video_params)
      redirect_to admin_manager_videos_path, notice: 'You have updated a video'
    else
      render action: :edit
    end
  end

  def destroy
      set_video
      @video.destroy
      redirect_to admin_manager_videos_path(@video), notice: 'You have successfully deleted a video.'
    end

  private

  def set_video
    @video ||= ManagerVideo.find(params[:id])
  end

  def set_videos
    @videos = ManagerVideo.all
    @videos = @videos.by_language(params[:language]) unless params[:language].nil? || params[:language].blank?
    @videos = @videos.by_category(params[:category]) unless params[:category].nil? || params[:category].blank?
  end

  def new_video
    @video = ManagerVideo.new
  end

  def video_params
    params.require(:manager_video).permit(:url, :video_type, :category, :language)
  end
end
