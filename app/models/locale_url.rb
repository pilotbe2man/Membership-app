# == Schema Information
#
# Table name: locale_urls
#
#  id         :integer          not null, primary key
#  url        :string
#  language   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LocaleUrl < ActiveRecord::Base
end
