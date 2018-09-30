# == Schema Information
#
# Table name: sub_task_completes
#
#  id                    :integer          not null, primary key
#  submitter_id          :integer
#  todo_task_complete_id :integer
#  sub_task_id           :integer
#  completion_date       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  result                :integer          default("0")
#

require 'rails_helper'

RSpec.describe SubTaskComplete, type: :model do
  describe "#assign_task_completion_date after_update callback" do
    let(:todo)               { create(:single_todo, daycare: FactoryGirl.create(:daycare)) }
    let(:todo_complete)      { create(:todo_complete, todo: todo)}
    let(:todo_task)          { create(:todo_task, todo: todo, task_type: 'local')}
    let(:todo_task_complete) { create(:pending_todo_task_complete, todo_complete: todo_complete) }
    let(:sub_task)           { create(:sub_task, todo_task: todo_task, sub_task_type: 'local') }
    let(:sub_task_complete)  { create(:pending_sub_task_complete, todo_task_complete: todo_task_complete, sub_task: sub_task) }


    it "should call the set_default method after save" do
      SubTaskComplete._update_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:assign_task_completion_date).should == true
    end

    context "if all associated tasks are completed" do
      let(:now) { Time.now }

      it "should update the parent record completion_date attribute" do
        Timecop.freeze(now)

        expect{
          sub_task_complete.pass!
        }.to change{
          sub_task_complete.todo_task_complete.completion_date
        }.from(nil).to(now)
      end
    end

    context "if all associated sub-tasks are not completed" do
      let!(:sub_task_complete_2) { create(:pending_sub_task_complete, todo_task_complete: todo_task_complete, sub_task: sub_task)}

      it "should not update the parent record completion_date attribute" do
        expect{
          sub_task_complete.pass!
        }.to_not change{
          sub_task_complete.todo_task_complete.completion_date
        }
      end
    end
  end

end
