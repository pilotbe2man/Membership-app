# == Schema Information
#
# Table name: todo_task_completes
#
#  id               :integer          not null, primary key
#  submitter_id     :integer
#  todo_complete_id :integer
#  todo_task_id     :integer
#  completion_date  :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  result           :integer          default("0")
#

require 'rails_helper'

RSpec.describe TodoTaskComplete, type: :model do

    describe "#assign_parent_completion_date after_update callback" do
        let(:todo_complete) { create(:todo_complete) }
        let(:todo_task_complete) { create(:pending_todo_task_complete, todo_complete: todo_complete) }

        it "should call the set_default method after save" do
            TodoTaskComplete._update_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:assign_parent_completion_date).should == true
        end

        context "if all associated tasks are completed" do
            let(:now) { Time.now }

            it "should update the parent record completion_date attribute" do
                Timecop.freeze(now)
                expect{
                    todo_task_complete.pass!
                }.to change{
                    todo_task_complete.todo_complete.completion_date
                }.from(nil).to(now)
            end
        end

        context "if all associated tasks are not completed" do
            let!(:todo_task_complete_2) { create(:pending_todo_task_complete, todo_complete: todo_complete)}

            it "should not update the parent record completion_date attribute" do
                expect{
                    todo_task_complete.pass!
                }.to_not change{
                    todo_task_complete.todo_complete.completion_date
                }
            end
        end
    end
end
