# == Schema Information
#
# Table name: illnesses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string
#

require 'rails_helper'

RSpec.describe Illness, type: :model do

  describe '#create' do

    it 'should return an error when name is blank' do
      illness = build(:illness, name: nil)

      expect(illness.valid?).to be_falsy
    end

    it 'should return an error when code is blank' do
      illness = build(:illness, code: nil)

      expect(illness.valid?).to be_falsy
    end

    it 'should return an error when a code already exists' do
      create(:illness, code: 'flu')

      expect{ create(:illness, code: 'flu') }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end
end
