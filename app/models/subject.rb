# == Schema Information
#
# Table name: subjects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deactivated_at :datetime
#

class Subject < ActiveRecord::Base
  include Deactivatable

  validates :title,    presence: true
end
