# == Schema Information
#
# Table name: doctor_specializations
#
#  id                        :integer          not null, primary key
#  user_profile_id           :integer
#  medical_specialization_id :integer
#  deactivated_at            :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class DoctorSpecialization < ActiveRecord::Base

  belongs_to :user_profile
  belongs_to :medical_specialization
end
