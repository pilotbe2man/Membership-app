class AddColumnLanguageToSurveySubjects < ActiveRecord::Migration
  def change
    add_column :survey_subjects, :language, :string
  end
end
