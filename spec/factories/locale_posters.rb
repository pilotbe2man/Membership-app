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

FactoryGirl.define do
  factory :locale_poster do
    type 1
    poster ""
    language "MyString"
  end
end
