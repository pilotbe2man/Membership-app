# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string
#  key            :string
#  value          :text
#  interpolations :text
#  is_proc        :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Translation < ActiveRecord::Base
end
