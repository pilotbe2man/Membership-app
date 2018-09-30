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

class UserTodoDestroy < ActiveRecord::Base
    belongs_to :user
    belongs_to :todo

    validates :user_id, :todo_id,                         presence: true
end
