# == Schema Information
#
# Table name: user_daycares
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserDaycare < ActiveRecord::Base
    belongs_to :user
    belongs_to :daycare

    accepts_nested_attributes_for :user
end
