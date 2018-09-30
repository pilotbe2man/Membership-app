# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("0")
#  name                   :string
#  stripe_customer_token  :string
#  department_id          :integer
#  trial_end_date         :datetime
#  email_confirmed        :boolean          default("false")
#  confirm_token          :string
#  deposit_required       :boolean          default("false")
#  card_number            :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {create(:user)}

  it 'should check for user first sign in' do
    expect(user.newly_signed_up?).to eq false    
  end

  it 'should activate email'do
    user.email_activate
    expect(user.email_confirmed).to eq true
    expect(user.confirm_token).to eq nil
  end

  # it 'should return confirmation token' do
  #   expect(user.confirmation_token).to eq ''
  # end
end
