# == Schema Information
#
# Table name: todos
#
#  id                    :integer          not null, primary key
#  title                 :string
#  iteration_type        :integer          default("0")
#  frequency             :integer          default("0")
#  daycare_id            :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  completion_date_type  :integer          default("0")
#  completion_date_value :integer          default("1")
#  language              :string
#

FactoryGirl.define do
    factory :todo do
        title { Faker::Lorem.word}
        frequency 'week'
        language 'English'

        factory :single_todo do
            iteration_type { 'single' }
        end

        factory :recurring_todo do
            iteration_type { 'recurring' }
        end

        after(:build) do |todo|
            todo.icon = build(:icon_attachment, attachable: nil)
        end

        association :user
        association :daycare
    end

end
