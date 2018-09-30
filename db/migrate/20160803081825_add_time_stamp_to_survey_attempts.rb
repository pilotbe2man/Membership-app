class AddTimeStampToSurveyAttempts < ActiveRecord::Migration
  def change
    add_column :survey_attempts, :created_at, :datetime
    add_column :survey_attempts, :updated_at, :datetime
  end
end
