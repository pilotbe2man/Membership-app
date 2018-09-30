# == Schema Information
#
# Table name: survey_surveys
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  attempts_number   :integer          default("0")
#  finished          :boolean          default("false")
#  active            :boolean          default("true")
#  created_at        :datetime
#  updated_at        :datetime
#  survey_subject_id :integer
#  weight            :integer          default("0")
#  deactivated_at    :datetime
#  remote_id         :integer
#

class SurveySurvey < ActiveRecord::Base
  include Deactivatable

  belongs_to :survey_subjects
  has_many :questions, class_name: Survey::Question, dependent: :destroy
  has_many :attempts, class_name: SurveyAttempts, dependent: :destroy
end
