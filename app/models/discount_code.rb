# == Schema Information
#
# Table name: discount_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  value      :integer          default("0")
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DiscountCode < ActiveRecord::Base

    has_many :discount_code_users,              dependent: :restrict_with_exception
    has_many :users,                            through: :discount_code_users

    validates :value, :code,                    presence: true
    validates :code,                            uniqueness: true

    enum status: [:active, :disabled]
end
