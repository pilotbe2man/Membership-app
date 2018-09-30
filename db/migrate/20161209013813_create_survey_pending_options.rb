class CreateSurveyPendingOptions < ActiveRecord::Migration
  def change
    create_table :survey_pending_options do |t|
      t.integer :user_id
      t.integer :survey_id
      t.integer :option_id
      t.integer :question_id
      t.integer :subject_id
      t.boolean :completed
    end
  end
end
