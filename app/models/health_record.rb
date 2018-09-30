# == Schema Information
#
# Table name: health_records
#
#  id             :integer          not null, primary key
#  protocol_code  :string
#  owner_id       :integer
#  owner_type     :string
#  recorder_id    :integer
#  recorder_type  :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  daycare_id     :integer
#  department_id  :integer
#

class HealthRecord < ActiveRecord::Base

  paginates_per 5

  belongs_to :owner,                                       polymorphic: true
  belongs_to :recorder,                                    polymorphic: true
  belongs_to :daycare
  belongs_to :department
  has_many   :health_record_components

  validates :protocol_code, :owner_id, :recorder_id,       presence: true

  scope :by_recorder,                                      ->(recorder){ where(recorder_id: recorder.id, recorder_type: recorder.class.name) }

  ['Child', 'Department'].each do |possible_owner|
    define_method "for_#{possible_owner.downcase}?" do
      possible_owner == owner_type
    end
  end

  def illness_name
    self.health_record_components.each do |item|
      if item.code == 'illness_code'
        return item.pretty_value
      end
    end
    return ""
  end

  def illness_id
    self.health_record_components.each do |item|
      if item.code == 'illness_code'
        return item.pretty_illness_id
      end
    end
    return ""
  end
end
