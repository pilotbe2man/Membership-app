# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  source_id   :integer
#  source_type :string
#  target_id   :integer
#  archived    :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# can be used for Message and Todo notifications

FactoryGirl.define do
  factory :message_notification, class: 'Notification' do
    association :target, factory: :user
    association :source, factory: :message
  end
end
