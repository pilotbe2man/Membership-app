class AddWeightToSurveySurveys < ActiveRecord::Migration
    def change
        add_column :survey_surveys, :weight, :integer, default: 0
    end
end
