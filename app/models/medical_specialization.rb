# == Schema Information
#
# Table name: medical_specializations
#
#  id             :integer          not null, primary key
#  name           :string
#  code           :string
#  added_by       :integer
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class MedicalSpecialization < ActiveRecord::Base

  validates :code, :name, presence: true
  validates :code, uniqueness: true

end
