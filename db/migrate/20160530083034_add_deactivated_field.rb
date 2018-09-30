class AddDeactivatedField < ActiveRecord::Migration
  def change
    add_column :attachments,      :deactivated_at, :datetime
    add_column :subjects,         :deactivated_at, :datetime
    add_column :survey_options,   :deactivated_at, :datetime
    add_column :survey_questions, :deactivated_at, :datetime
    add_column :survey_subjects,  :deactivated_at, :datetime
    add_column :survey_surveys,   :deactivated_at, :datetime
  end
end
