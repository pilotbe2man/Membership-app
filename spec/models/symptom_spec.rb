# == Schema Information
#
# Table name: symptoms
#
#  id         :integer          not null, primary key
#  illness_id :integer
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Symptom, type: :model do
  it { should belong_to(:illness) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of :code}
end
