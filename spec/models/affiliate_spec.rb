# == Schema Information
#
# Table name: affiliates
#
#  id             :integer          not null, primary key
#  name           :string
#  address        :string
#  postcode       :string
#  country        :string
#  telephone      :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  url            :string
#
# Indexes
#
#  index_affiliates_on_name  (name)
#

require 'rails_helper'

RSpec.describe Affiliate, type: :model do
	it { should have_one(:profile_image).class_name('Attachment') }
	it { should have_many(:user_affiliates) }
	it { should have_many(:users) }

	it { should validate_presence_of :name }
	it { should validate_presence_of :address }
	it { should validate_presence_of :postcode }
	it { should validate_presence_of :telephone }
	it { should accept_nested_attributes_for(:user_affiliates) }
	it { should accept_nested_attributes_for(:profile_image) }
end
