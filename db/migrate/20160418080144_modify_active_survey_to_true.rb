class ModifyActiveSurveyToTrue < ActiveRecord::Migration
    def change
        change_column :survey_surveys, :active, :boolean, default: true
    end
end
