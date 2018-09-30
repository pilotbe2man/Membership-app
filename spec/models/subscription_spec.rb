require 'rails_helper'
require 'fake_stripe'

RSpec.describe Subscription, type: :model do
  let(:subscription){ create(:subscription) }
  let(:discount_code){ create(:discount_code, code: 'Free10') }

  describe '#save_with_payment' do
    it 'assigns stripe customer token from return object and assigns discount code relation' do
      FakeStripe.stub_stripe
      expect(subscription.save_with_payment(discount_code)).to eq true  
    end
  end
end