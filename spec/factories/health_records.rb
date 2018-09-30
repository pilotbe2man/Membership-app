# == Schema Information
#
# Table name: health_records
#
#  id             :integer          not null, primary key
#  protocol_code  :string
#  owner_id       :integer
#  owner_type     :string
#  recorder_id    :integer
#  recorder_type  :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  daycare_id     :integer
#  department_id  :integer
#

FactoryGirl.define do
  factory :health_record do
    protocol_code {'protocol'}


    association :owner, factory: :user
    association :recorder, factory: :user
    association :daycare, factory: :daycare
    association :department, factory: :department
  end
end