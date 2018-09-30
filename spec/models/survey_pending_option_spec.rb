# == Schema Information
#
# Table name: survey_pending_options
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  survey_id   :integer
#  option_id   :integer
#  question_id :integer
#  subject_id  :integer
#  completed   :boolean
#

require 'rails_helper'

RSpec.describe SurveyPendingOption, type: :model do
end
