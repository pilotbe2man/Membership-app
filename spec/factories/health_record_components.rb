# == Schema Information
#
# Table name: health_record_components
#
#  id               :integer          not null, primary key
#  health_record_id :integer
#  code             :string
#  value            :string
#  deactivate_at    :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_health_record_components_on_health_record_id  (health_record_id)
#

FactoryGirl.define do
  factory :health_record_component do
    code {'illness_code'}
    value {'zxcvb'}
    association :health_record, factory: :health_record
  end
end