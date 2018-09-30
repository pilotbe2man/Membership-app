# == Schema Information
#
# Table name: payment_starts
#
#  id         :integer          not null, primary key
#  period     :integer
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentStart < ActiveRecord::Base
end
