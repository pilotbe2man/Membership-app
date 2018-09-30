require 'rails_helper'

describe TodoTaskCompletesController do

    login_user

    describe 'PATCH #update' do
        let(:user) { subject.send(:current_user) }
        let(:daycare) { create(:daycare) }
        let!(:user_daycare) { create(:user_daycare, user: user, daycare: daycare) }
        let(:todo) { create(:todo, daycare: daycare) }
        let(:todo_task) { create(:todo_task, todo: todo) }
        let(:todo_complete) { create(:todo_complete, todo: todo, submitter: user) }
        let!(:todo_task_complete) { create(:todo_task_complete, submitter: user, todo_complete: todo_complete, todo_task: todo_task)}

        it "should assign the requested todo_task_complete to @todo_task_complete" do
            patch :update , id: todo_task_complete.id
            expect(assigns(:todo_task_complete)).to eq todo_task_complete
        end

        it "should update the todo_task_comlete record" do
            patch :update, id: todo_task_complete.id
            todo_task_complete.reload
            expect(todo_task_complete.pass?).to eq true
            expect(todo_task_complete.completion_date).to_not eq nil
        end

        it "should redirect the user to their dashboard" do
            patch :update , id: todo_task_complete.id
            expect(response).to redirect_to(todo_todo_complete_url(todo, todo_complete))
        end
    end
end