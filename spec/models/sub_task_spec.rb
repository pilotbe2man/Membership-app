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

require 'rails_helper'

RSpec.describe SubTask, type: :model do

  describe '#is_admin_global?' do

    context 'if creator is an admin' do
      it 'should return true' do
        admin = create(:admin_user)
        todo = create(:single_todo, daycare: nil, user: admin)
        todo_task = create(:todo_task, todo: todo)
        sub_task = create(:sub_task, todo_task: todo_task)

        expect(todo.global?).to eq true
        expect(todo_task.global?).to eq true
        expect(sub_task.global?).to eq true
      end
    end

    context 'if creator is not an admin' do
      it 'should return false' do
        mgr = create(:user)
        todo = create(:single_todo, daycare: create(:daycare), user: mgr)
        todo_task = create(:todo_task, todo: todo, task_type: 'local')
        sub_task = create(:sub_task, todo_task: todo_task, sub_task_type: 'local')

        expect(todo.global?).to eq false
        expect(todo_task.global?).to eq false
        expect(sub_task.global?).to eq false
      end
    end
  end

end
