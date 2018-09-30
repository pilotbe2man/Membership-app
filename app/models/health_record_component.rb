# == Schema Information
#
# Table name: health_record_components
#
#  id               :integer          not null, primary key
#  health_record_id :integer
#  code             :string
#  value            :string
#  deactivate_at    :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_health_record_components_on_health_record_id  (health_record_id)
#

class HealthRecordComponent < ActiveRecord::Base

  belongs_to :health_record

  validates :health_record_id, :code,              presence: true

  def pretty_value
    if code == 'illness_code'
      illness = Illness.find_by(code: value)
      (illness.nil?) ? "" : illness.name
    elsif code == 'symptom_codes'
      codes = JSON.parse(value)
      Symptom.where(code: codes).map(&:name).join(', ')
    else
      value
    end
  end

  def pretty_illness_id
    if code == 'illness_code'
      illness = Illness.find_by(code: value)
      (illness.nil?) ? "" : illness.id
    end
  end

end
