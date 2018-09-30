# == Schema Information
#
# Table name: user_occurrences
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserOccurrence < ActiveRecord::Base
    belongs_to :user
    belongs_to :todo

    validates :user_id, :todo_id,                                   presence: true

    enum status: [:active, :inactive]
end
