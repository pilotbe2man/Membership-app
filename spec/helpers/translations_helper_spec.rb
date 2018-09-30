require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TranslationsHelper. For example:
#
# describe TranslationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TranslationsHelper, type: :helper do
  describe '#translation_keys' do
    it 'should return en keys' do
      expect(translation_keys('en')).to eq ['en.pages.nav_bar.home']
    end

    it 'should return en keys' do
      expect(translation_keys('jp')).to eq ["welcome", "site_description"]
    end

    it 'should return en keys' do
      expect(translation_keys('sp')).to eq [ "en.pages.nav_bar.home" ]
    end
  end

  describe '#translation_for_key' do
    let(:translation){ create(:translation) }
    let(:translation1){ create(:translation, key: 'en.pages.nav_bar.home') }

    it 'should return the translation for the key' do
      tran = []
      tran << translation
      tran << translation1
      expect(translation_for_key(tran,'en.pages.nav_bar.home')).to eq translation1
    end
  end
end
