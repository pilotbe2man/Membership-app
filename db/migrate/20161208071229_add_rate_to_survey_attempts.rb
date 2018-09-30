class AddRateToSurveyAttempts < ActiveRecord::Migration
  def change
    add_column :survey_attempts, :rate, :decimal, :precision => 5, :scale => 2 
  end
end
