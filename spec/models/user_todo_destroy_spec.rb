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

require 'rails_helper'

RSpec.describe UserTodoDestroy, type: :model do
end
