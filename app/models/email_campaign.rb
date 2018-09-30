class EmailCampaign < ActiveRecord::Base
  scope :by_language,     	->(search) { where("(LOWER(language) LIKE :search)", :search => "%#{search.downcase}%") }
end
