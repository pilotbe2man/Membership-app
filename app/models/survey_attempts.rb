# == Schema Information
#
# Table name: survey_attempts
#
#  id               :integer          not null, primary key
#  participant_id   :integer
#  participant_type :string
#  survey_id        :integer
#  winner           :boolean
#  score            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  remote_id        :integer
#  rate             :decimal(5, 2)
#

class SurveyAttempts < ActiveRecord::Base
  belongs_to :survey, class_name: SurveySurvey
  has_many   :survey_answers, foreign_key: :attempt_id, dependent: :destroy
end
