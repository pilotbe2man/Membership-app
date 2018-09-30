# == Schema Information
#
# Table name: message_subjects
#
#  id                :integer          not null, primary key
#  title             :string
#  parent_subject_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language          :string
#
# Indexes
#
#  index_message_subjects_on_parent_subject_id  (parent_subject_id)
#

# MessageSubject can have many message sub-subjects
# MessageSubject can have a parent subject, referenced in the parent_subject_id
class MessageSubject < ActiveRecord::Base
  belongs_to :parent_subject, class_name: 'MessageSubject'
  has_many   :sub_subjects, ->{ order(title: :asc) }, class_name: 'MessageSubject', foreign_key: 'parent_subject_id'

  has_many :message_templates, foreign_key: 'sub_subject_id' do
    def for_role(role)
      detect{|temp| temp.target_role == role}
    end
  end

  scope :main_subjects, -> { where(parent_subject_id: nil)
                                .where.not("message_subjects.title LIKE :search", :search => "%#{ENV['SURVEY_TEMPLATE_SUBJECT']}%")
                                .where.not("message_subjects.title LIKE :search", :search => "%#{ENV['EMAIL_VERIFICATION_SUBJECT']}%").order(title: :asc) }

  scope :template_subjects, -> { where(parent_subject_id: nil)
                                .where.not("message_subjects.title LIKE :search", :search => "%#{ENV['SURVEY_TEMPLATE_SUBJECT']}%")
                                .where.not("message_subjects.title LIKE :search", :search => "%#{ENV['EMAIL_VERIFICATION_SUBJECT']}%").order(title: :asc) }
  scope :invite_subjects, -> { where(parent_subject_id: nil).where("message_subjects.title LIKE :search", :search => "%#{ENV['SURVEY_TEMPLATE_SUBJECT']}%").order(title: :asc) }
  scope :verify_subjects, -> { where(parent_subject_id: nil).where("message_subjects.title LIKE :search", :search => "%#{ENV['EMAIL_VERIFICATION_SUBJECT']}%").order(title: :asc) }
  scope :confirm_subjects, -> { where(parent_subject_id: nil).where("message_subjects.title LIKE :search", :search => "%#{ENV['EMAIL_CONFIRMATION_SUBJECT']}%").order(title: :asc) }

  scope :main_title_like,      ->(search) { where("LOWER(message_subjects.title) LIKE :search", :search => "%#{search.downcase}%") }
  scope :main_by_language,     ->(search) { where("(LOWER(message_subjects.language) LIKE :search)", :search => "%#{search.downcase}%") }

  validates :title, :language, presence: true
end
