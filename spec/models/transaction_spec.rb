# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  amount     :decimal(8, 2)
#  currency   :string
#  card_num   :string
#  charge_id  :string
#  user_id    :integer
#  deposit    :boolean          default("false")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Transaction, type: :model do
end
