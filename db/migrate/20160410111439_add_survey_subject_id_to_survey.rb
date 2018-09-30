class AddSurveySubjectIdToSurvey < ActiveRecord::Migration
    def change
        add_column :survey_surveys, :survey_subject_id, :integer
    end
end
