require 'rails_helper'

RSpec.describe Daycare, type: :model do
  let(:daycare) { create(:daycare) }

  it 'check if the daycare contains a manager user with an active subscription or trial' do
    expect(daycare.active_subscription?).to eq false
  end

  it 'checks if the daycare contains a manager user with an active subscription' do
    expect(daycare.subscribed?).to eq false
  end

  it 'should list all completed todos' do
    expect(daycare.all_completed_todos).to eq []
  end

  it 'should list all incomplete todos' do
    expect(daycare.all_incomplete_todos).to eq []
  end

   it 'should list all available todos' do
    expect(daycare.all_available_todos).to eq []
  end

   it 'should list all todos within a daycare' do
    expect(daycare.all_todos).to eq []
  end

  it 'should destroy others' do
    daycare.destroy_others
    expect(daycare.todo_destroys).to eq []
    expect(daycare.users).to eq []
    expect(daycare.user_daycares).to eq []
    expect(daycare.children).to eq []
    expect(daycare.departments).to eq []
    expect(daycare.surveys).to eq []
    expect(daycare.survey_subjects).to eq []
    expect(daycare.health_records).to eq []
    expect(daycare.local_todos).to eq []
    expect(daycare.discussions).to eq []
    expect(daycare.discussion_participants).to eq []
  end

  describe 'care type text' do
    it 'should return Independent' do
      expect(daycare.care_type_text).to eq 'Independent'
    end

    it 'should return empty string' do
      daycare = build(:daycare, care_type: 2)
      expect(daycare.care_type_text).to eq ''
    end
  end
end