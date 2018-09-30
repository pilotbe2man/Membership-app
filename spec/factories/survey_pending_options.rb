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

FactoryGirl.define do
  factory :survey_pending_option do
    user_id 1
    survey_id 1
    option_id 1
  end
end
