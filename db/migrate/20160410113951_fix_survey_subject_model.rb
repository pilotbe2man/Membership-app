class FixSurveySubjectModel < ActiveRecord::Migration
    def change
        rename_column :survey_subjects, :name, :title
        add_column :survey_subjects, :description, :text
    end
end
