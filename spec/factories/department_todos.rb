# == Schema Information
#
# Table name: department_todos
#
#  id            :integer          not null, primary key
#  todo_id       :integer
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :department_todo do
    todo_id 1
    department_id 1
  end
end
