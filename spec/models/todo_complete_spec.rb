# == Schema Information
#
# Table name: todo_completes
#
#  id              :integer          not null, primary key
#  submitter_id    :integer
#  todo_id         :integer
#  completion_date :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default("0")
#

require 'rails_helper'

RSpec.describe TodoComplete, type: :model do

    describe "recurring record validation" do
        let(:recurring_todo) { create(:recurring_todo) }
        let(:single_todo) { create(:single_todo) }

        context "if single todo and more than one todo_complete" do
            let!(:todo_complete) { create(:todo_complete, todo: single_todo ) }
            let(:new_todo_complete) { build(:todo_complete, todo: single_todo) }

            it "should return true in validation" do
                expect(new_todo_complete.valid?).to eq true
            end

            it "should create a new TodoComplete record" do
                expect{
                    new_todo_complete.save!
                }.to change(TodoComplete, :count).by(1)
            end
        end

        context "if recurring todo and first todo_complete" do
            let(:new_todo_complete) { build(:todo_complete, todo: recurring_todo) }

            it "should return true in validation" do
                expect(new_todo_complete.valid?).to eq true
            end

            it "should create a new TodoComplete record" do
                expect{
                    new_todo_complete.save!
                }.to change(TodoComplete, :count).by(1)
            end
        end

        # context "if recurring todo and more than one todo_complete" do
        #     let(:user) { create(:user) }
        #     let!(:todo_complete) { create(:todo_complete, todo: recurring_todo, submitter: user) }
        #     let(:new_todo_complete) { build(:todo_complete, todo: recurring_todo, submitter: user) }

        #     it "should return false in validation" do
        #         expect(new_todo_complete.valid?).to eq false
        #     end

        #     it "should return an error" do
        #         new_todo_complete.valid?
        #         expect(new_todo_complete.errors.messages[:submitter_id]).to eq ["has already been taken"]
        #     end
        # end
    end

    describe "#complete? method" do

        context "if completion date is nil" do
            let(:todo_complete) { create(:todo_complete) }

            it "should return false" do
                expect(todo_complete.complete?).to eq false
            end
        end

        context "if completion date is not nil" do
            let(:todo_complete) { create(:todo_complete, completion_date: 2.days.ago.to_date) }

            it "should return true" do
                expect(todo_complete.complete?).to eq true
            end
        end
    end

    describe "#pass? and #pending method" do
        let(:todo_complete) { create(:todo_complete) }
        context "if all tasks are successfully completed" do
            let(:passed_task){ create(:passed_todo_task_complete, todo_complete: todo_complete) }

            it "pass should return true" do
                expect(todo_complete.pass?).to eq true
            end

            it "pending should return true" do
                expect(todo_complete.pending?).to eq true
            end
        end
    end


    describe "#todo_recurring? method" do

        context "if associated todo is recurring" do
            let(:todo) { create(:recurring_todo) }
            let(:todo_complete) { create(:todo_complete, todo: todo) }

            it "should return true" do
                expect(todo_complete.todo_recurring?).to eq true
            end
        end

        context "if associated todo is not recurring" do
            let(:todo) { create(:single_todo) }
            let(:todo_complete) { create(:todo_complete, todo: todo) }

            it "should return false" do
                expect(todo_complete.todo_recurring?).to eq false
            end
        end
    end

    describe "#assign_user_occurrence after_create callback" do
        let(:todo) { create(:recurring_todo) }
        let(:todo_complete) { create(:todo_complete, todo: todo) }

        it "should call the set_default method after save" do
            TodoComplete._create_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:assign_user_occurrence).should == true
        end

        it "should create a UserOccurrence record" do
            expect{
                todo_complete
            }.to change(UserOccurrence, :count).by(1)
        end
    end

    describe "#todo_task_completes after_create callback" do
        let(:todo) { create(:recurring_todo) }
        let!(:task_1) { create(:todo_task, todo: todo) }
        let!(:task_2) { create(:todo_task, todo: todo) }
        let(:todo_complete) { create(:todo_complete, todo: todo) }


        it "should call the set_default method after save" do
            TodoComplete._create_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:todo_task_completes).should == true
        end

        it "should create TodoTaskComplete records" do
            expect{
                todo_complete
            }.to change(TodoTaskComplete, :count).by(2)
        end

        it "should contain the correct task data" do
            todo_complete
            expect(todo_complete.task_completes.map(&:todo_task_id)).to eq todo.tasks.map(&:id)
        end

    end
end
