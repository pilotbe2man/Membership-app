class AddRemoteIdToSurveyAttempts < ActiveRecord::Migration
  def change
    add_column :survey_attempts, :remote_id, :integer
  end
end
