# == Schema Information
#
# Table name: user_todo_destroys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_todo_destroy do
    user_id 1
    todo_id 1
  end
end
