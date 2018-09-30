require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  it { should have_many(:discount_code_users) }
  it { should have_many(:users) }

  it { should validate_presence_of :value }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of :code }
end
