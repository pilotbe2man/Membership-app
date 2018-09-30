class AddRemoteIdToSurveySurveys < ActiveRecord::Migration
  def change
    add_column :survey_surveys, :remote_id, :integer
    add_column :survey_questions, :remote_id, :integer
    add_column :survey_options, :remote_id, :integer
    add_column :survey_subjects, :remote_id, :integer
  end
end
