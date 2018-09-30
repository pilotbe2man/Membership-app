# == Schema Information
#
# Table name: todos
#
#  id                    :integer          not null, primary key
#  title                 :string
#  iteration_type        :integer          default("0")
#  frequency             :integer          default("0")
#  daycare_id            :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  completion_date_type  :integer          default("0")
#  completion_date_value :integer          default("1")
#  language              :string
#

require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:single_todo) { create(:single_todo) }

  describe "#global? method" do

    context "if todo has an associated daycare" do
      let(:daycare) { create(:daycare) }
      let(:todo) { create(:single_todo, daycare: daycare) }

      it "should return false" do
        expect(todo.global?).to eq false
      end
    end

    context "if todo has no associated daycare" do
      let(:todo) { create(:single_todo, daycare: nil, user: create(:admin_user)) }

      it "should return true" do
        expect(todo.global?).to eq true
      end
    end
  end

  describe "#local? method" do

    context "if todo has an associated daycare" do
      let(:daycare) { create(:daycare) }
      let(:todo) { create(:single_todo, daycare: daycare) }

      it "should return false" do
        expect(todo.local?).to eq true
      end
    end

    context "if todo has no associated daycare" do
      let(:todo) { create(:single_todo, daycare: nil, user: create(:admin_user)) }

      it "should return true" do
        expect(todo.local?).to eq false
      end
    end
  end

  describe "#frequency_to_time method" do
      let(:day_todo) { create(:recurring_todo, frequency: 'day') }
      let(:week_todo) { create(:recurring_todo, frequency: 'week') }
      let(:month_todo) { create(:recurring_todo, frequency: 'month') }
      let(:year_todo) { create(:recurring_todo, frequency: 'year') }

      it "should return the correct datetime for the frequency" do
        expect(day_todo.frequency_to_time).to eq 1.days.ago.to_date
        expect(week_todo.frequency_to_time).to eq 7.days.ago.to_date
        expect(month_todo.frequency_to_time).to eq 1.month.ago.to_date
        expect(year_todo.frequency_to_time).to eq 1.year.ago.to_date
      end
  end

  describe '#in_progress?' do
    let(:user) { create(:user) }
    # let(:todo_complete) { create(:todo_complete, todo: todo, submitter: user) }
    it 'should return false ' do
      expect(single_todo.in_progress?(user.id)).to eq false
    end
  end

  it 'should set frequency to nil' do
    expect(single_todo.set_frequency_for_single).to eq nil
  end

  it 'should retuen completion_date_type to user friendly string' do
    expect(single_todo.completion_date).to eq 'Day'
  end

  describe '#recurring_available' do
    let(:day_todo) { create(:recurring_todo, frequency: 'day') }
    # let(:todo_complete) { create(:todo_complete, todo: todo) }

    context 'if it is a single type todo' do
      it 'should return true' do
        expect(single_todo.recurring_available).to eq true
      end
    end

    context 'if todo_complete is nil' do
      it 'should return true' do
        expect(day_todo.recurring_available).to eq true
      end
    end
  end

  it 'checks if user is admin or global' do
    expect(single_todo.is_admin_global?).to eq nil
  end
end
