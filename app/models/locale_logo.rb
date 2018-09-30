# == Schema Information
#
# Table name: locale_logos
#
#  id                  :integer          not null, primary key
#  logo_type           :integer
#  logo_file_name      :string
#  logo_content_type   :string
#  logo_file_size      :integer
#  logo_updated_at     :datetime
#  language            :string
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  address1            :string
#  address2            :string
#  email               :string
#  phone_number        :string
#  title               :string
#  copyright           :string
#  upgrade_notifier    :string
#  invitation_notifier :string
#

class LocaleLogo < ActiveRecord::Base
  has_attached_file :logo, path: "logos/:id_partition/:filename"

  #validates attachment of files
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  scope :by_language,     	->(search) { where("(LOWER(locale_logos.language) LIKE :search)", :search => "%#{search.downcase}%") }
  scope :by_type_language,  ->(type, lang) { where("(LOWER(locale_logos.language) LIKE :lang) AND (locale_logos.logo_type = :type)", {:lang => "%#{lang.downcase}%", :type => type}) }

end
