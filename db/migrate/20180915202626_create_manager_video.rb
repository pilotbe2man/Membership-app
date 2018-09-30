class CreateManagerVideo < ActiveRecord::Migration
  def change
    create_table :manager_videos do |t|
      t.string   "url"
      t.string   "language"
      t.string   "video_type"
      t.string   "category"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
