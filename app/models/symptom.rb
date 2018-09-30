# == Schema Information
#
# Table name: symptoms
#
#  id         :integer          not null, primary key
#  illness_id :integer
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Symptom < ActiveRecord::Base
  belongs_to :illness

  validates :code, :name,                 presence: true
  validates :code,                        uniqueness: true

end
