# == Schema Information
#
# Table name: survey_questions
#
#  id             :integer          not null, primary key
#  survey_id      :integer
#  text           :string
#  created_at     :datetime
#  updated_at     :datetime
#  deactivated_at :datetime
#  remote_id      :integer
#

class SurveyQuestion < ActiveRecord::Base
  include Deactivatable

  belongs_to :survey_survey, class_name: SurveySurvey, foreign_key: :survey_id
  has_many :options, class_name: Survey::Option, dependent: :destroy
end
