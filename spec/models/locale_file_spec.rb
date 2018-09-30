# == Schema Information
#
# Table name: locale_files
#
#  id                           :integer          not null, primary key
#  name                         :string
#  preview_link                 :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  file_file_name               :string
#  file_content_type            :string
#  file_file_size               :integer
#  file_updated_at              :datetime
#  online_training_file_name    :string
#  online_training_content_type :string
#  online_training_file_size    :integer
#  online_training_updated_at   :datetime
#  logo_file_name               :string
#  logo_content_type            :string
#  logo_file_size               :integer
#  logo_updated_at              :datetime
#  language_name                :string
#  language_short_name          :string
#

require 'rails_helper'

RSpec.describe LocaleFile, type: :model do
end
