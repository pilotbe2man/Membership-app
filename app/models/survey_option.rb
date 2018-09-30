# == Schema Information
#
# Table name: survey_options
#
#  id             :integer          not null, primary key
#  question_id    :integer
#  weight         :integer          default("0")
#  text           :string
#  correct        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  deactivated_at :datetime
#  remote_id      :integer
#

class SurveyOption < ActiveRecord::Base
  include Deactivatable

  belongs_to :survey_questions, foreign_key: :question_id
end
