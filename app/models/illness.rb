# == Schema Information
#
# Table name: illnesses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string
#

class Illness < ActiveRecord::Base
    has_attached_file :worker_guide, path: "worker_guide/:id_partition/:filename"
    has_attached_file :parent_guide, path: "parent_guide/:id_partition/:filename"

    #validates attachment of files
    validates_attachment_content_type :worker_guide, content_type: /./
    validates_attachment_content_type :parent_guide, content_type: /./


  has_many :symptoms

  validates :code, :name,          presence: true
  validates :code,                 uniqueness: true

  accepts_nested_attributes_for :symptoms, allow_destroy: true

  scope :name_like,      ->(search) { where("LOWER(illnesses.name) LIKE :search", :search => "%#{search.downcase}%") }
  scope :code_like,      ->(search) { where("LOWER(illnesses.code) LIKE :search", :search => "%#{search.downcase}%") }
  scope :by_language,    ->(search) { where("(LOWER(illnesses.language) LIKE :search)", :search => "%#{search.downcase}%") }

end
