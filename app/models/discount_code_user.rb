# == Schema Information
#
# Table name: discount_code_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  discount_code_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DiscountCodeUser < ActiveRecord::Base
    belongs_to :discount_code 
    belongs_to :user

    validates :discount_code_id,                    presence: true
    validates :user,                                presence: true
end
