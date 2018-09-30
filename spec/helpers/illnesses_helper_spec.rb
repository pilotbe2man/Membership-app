require 'rails_helper'

RSpec.describe IllnessesHelper, type: :helper do
  let(:daycare){ create(:daycare) }
  let(:current_user) { create(:user) }
  describe '#user_departments' do
    it 'departments' do
      create(:user_daycare, user: current_user, daycare: daycare)
      dep = create(:department, daycare: daycare, name: 'Support')
      expect(user_departments).to eq [{:id=>dep.id - 1, :name=>"Health"}, {:id=>dep.id, :name=>"Support"}]
    end
  end

  describe '#illness_list' do
    it 'return illness list' do
      create(:illness, code: 'b12', name: 'fever')
      expect(illness_list).to eq [{:code=>"b12", :name=>"fever"}]
    end
  end
end