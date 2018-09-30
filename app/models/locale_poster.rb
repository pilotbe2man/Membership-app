# == Schema Information
#
# Table name: locale_posters
#
#  id                  :integer          not null, primary key
#  poster_type         :integer
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  language            :string
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class LocalePoster < ActiveRecord::Base
  has_attached_file :poster, path: "posters/:id_partition/:filename"

  #validates attachment of files
  validates_attachment_content_type :poster, content_type: /./
  validates :poster_type, uniqueness: true

  POSTER_TYPES = {
                   1 => 'Food Handling',
                   2 => 'Diapering',
                   3 => 'Hand Hygiene',
                 }

  scope :by_language,       ->(search) { where("(LOWER(locale_posters.language) LIKE :search)", :search => "%#{search.downcase}%") }
  scope :by_poster_type,       ->(search) { where("(LOWER(locale_posters.poster_type) LIKE :search)", :search => "%#{search.downcase}%") }
  scope :by_type_language,  ->(type, lang) { where("(LOWER(locale_posters.language) LIKE :lang) AND (locale_posters.poster_type = :type)", {:lang => "%#{lang.downcase}%", :type => type}) }
end
