# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  parent_id     :integer
#  department_id :integer
#  birth_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Child < ActiveRecord::Base
    has_one :profile_image,                                 -> { where(attachable_type: 'ChildProfile') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
    belongs_to :parentee,                                   class_name: 'User', foreign_key: 'parent_id'
    belongs_to :department

    # <--- health conversations-related
    has_many :health_records,                               :as => :owner
    has_many :discussions,                                  -> { order "created_at ASC"}, :as => :subject
    has_many :collaborators,                                class_name: 'ChildCollaborator', dependent: :destroy
    has_many :collaboration_invites
    has_many :pending_collaborations,                       -> {where(status: 0)}, class_name: 'CollaborationInvite'
    # health conversations-related --->

    validates :name, :department_id,
                :birth_date,                                presence: true

    # validates :profile_image,                               presence: true

    scope :search_by_name,                                  -> (query) { where("name LIKE :search", search: "#{query}")}
    scope :search_by_birth_date,                            -> (birthdate) { where("birth_date <= :birthdate_1 AND birth_date >= :birthdate_2", birthdate_1: (Date.parse(birthdate) + 1), birthdate_2: (Date.parse(birthdate) - 1))}

    accepts_nested_attributes_for :profile_image

    delegate :daycare, to: :department

    after_create :initialize_collaborators
    def age
      now = Time.now.utc.to_date
      now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
    end

    def initialize_collaborators
      collaborators.find_or_create_by(collaborator: self.department)
      collaborators.find_or_create_by(collaborator: self.parentee)
    end
end
