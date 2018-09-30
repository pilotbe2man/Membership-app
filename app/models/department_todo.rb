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

class DepartmentTodo < ActiveRecord::Base
    belongs_to :todo
    belongs_to :department

    validates :department_id,                                 presence: true
end
