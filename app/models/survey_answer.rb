# == Schema Information
#
# Table name: survey_answers
#
#  id          :integer          not null, primary key
#  attempt_id  :integer
#  question_id :integer
#  option_id   :integer
#  correct     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class SurveyAnswer < ActiveRecord::Base
  belongs_to :survey_attempts, foreign_key: :attempt_id
  belongs_to :survey_questions, foreign_key: :question_id
  belongs_to :surveys_options, foreign_key: :option_id

end
