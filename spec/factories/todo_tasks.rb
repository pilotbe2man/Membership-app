# == Schema Information
#
# Table name: todo_tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  task_type   :integer          default("0")
#  language    :string
#

FactoryGirl.define do
    factory :todo_task do
        title { "Task-#{Faker::Lorem.word}" }
        description { Faker::Lorem.sentence }
        language {'English'}

        association :todo
    end
end
