# == Schema Information
#
# Table name: sub_tasks
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  todo_task_id   :integer
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_task_type  :integer          default("0")
#  language       :string
#

FactoryGirl.define do

  factory :sub_task do
    title { "Sub-task #{Faker::Lorem.word}" }
    description { Faker::Lorem.sentence }
    language { 'English' }

    association :todo_task
  end

end
