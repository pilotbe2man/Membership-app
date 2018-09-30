require 'rails_helper'

RSpec.describe HealthRecordComponent, type: :model do
  it 'should return the illness_name' do
    hc = create(:health_record_component)
    create(:illness, code: 'zxcvb', name: 'illness_name')
    expect(hc.pretty_value).to eq 'illness_name'
  end

  # it 'should return the symptoms' do
  #   hc = create(:health_record_component, code: 'symptom_codes')
  #   create(:symptom, code: 'zxcvb', name: 'symptoms_name' )
  #   expect(hc.pretty_value).to eq 'zxcvb'
  # end

  it 'should return the value' do
    hc = create(:health_record_component, code: 'random')
    expect(hc.pretty_value).to eq 'zxcvb'
  end
end