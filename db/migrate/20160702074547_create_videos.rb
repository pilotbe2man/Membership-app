class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.string :language
      t.string :video_type
      t.string :category

      t.timestamps null: false
    end
  end
end
