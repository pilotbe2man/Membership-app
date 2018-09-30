class ChangeTypeInManagerVideos < ActiveRecord::Migration
  def change
    remove_column :manager_videos, :video_type
    add_column :manager_videos, :video_type, :string
  end
end
