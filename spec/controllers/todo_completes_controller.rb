require 'rails_helper'

describe TodoCompletesController do

    login_user

    describe 'POST #create' do
        let(:user) { subject.send(:current_user) }
        let(:daycare) { create(:daycare) }
        let!(:user_daycare) { create(:user_daycare, user: user, daycare: daycare) }
        let!(:todo) { create(:todo, daycare: daycare) }

        it "should assign the requested todo to @todo" do
            post :create , todo_id: todo.id
            expect(assigns(:todo)).to eq todo
        end

        it "should redirect the user to their dashboard" do
            post :create , todo_id: todo.id
            expect(response).to redirect_to(todo_todo_complete_url(todo, assigns(:todo_complete)))
        end
    end
end