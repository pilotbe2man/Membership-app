# == Schema Information
#
# Table name: user_affiliates
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  affiliate_id   :integer
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_user_affiliates_on_affiliate_id  (affiliate_id)
#  index_user_affiliates_on_user_id       (user_id)
#

class UserAffiliate < ActiveRecord::Base
    belongs_to :user
    belongs_to :affiliate

    accepts_nested_attributes_for :user
end
