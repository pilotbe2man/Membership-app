# == Schema Information
#
# Table name: payment_modes
#
#  id         :integer          not null, primary key
#  period     :integer
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PaymentMode, type: :model do
end
