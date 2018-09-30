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

require 'rails_helper'

RSpec.describe TodoTask, type: :model do
    
end
